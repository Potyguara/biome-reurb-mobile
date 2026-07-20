import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_client.dart';
import '../../../core/auth/secure_session_storage.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import 'document_sync_database.dart';

final documentSyncRepositoryProvider = Provider<DocumentSyncRepository>((ref) {
  return DocumentSyncRepository(
    dio: ref.watch(dioProvider),
    database: ref.watch(appDatabaseProvider),
    sessionStorage: ref.watch(secureSessionStorageProvider),
  );
});

class DocumentSyncRepository {
  DocumentSyncRepository({
    required Dio dio,
    required AppDatabase database,
    required SecureSessionStorage sessionStorage,
  })  : _dio = dio,
        _database = database,
        _sessionStorage = sessionStorage;

  final Dio _dio;
  final AppDatabase _database;
  final SecureSessionStorage _sessionStorage;

  Future<DocumentSyncResult> synchronize({
    required String projectId,
    int limit = 500,
    bool pullAfterPush = true,
  }) async {
    final sourceDeviceId = await _sessionStorage.getOrCreateDeviceId();

    await _database.prepararIdentidadeDocumentos(
      projectId: projectId,
      sourceDeviceId: sourceDeviceId,
    );

    await _database.liberarDocumentosParaNovaTentativa(projectId);

    await _database.prepararDocumentosPendentes(
      projectId: projectId,
    );

    final pendingRows = await _database.listarDocumentosPendentes(
      projectId: projectId,
      limit: limit,
    );

    final attempted = pendingRows.length;

    var acceptedCount = 0;
    var rejectedCount = 0;
    var conflictCount = 0;
    var pulledCount = 0;

    try {
      if (pendingRows.isNotEmpty) {
        final queueIds = pendingRows
            .map((row) => _nullableText(row['queue_id']))
            .whereType<String>()
            .toList();

        await _database.marcarDocumentosComoSincronizando(queueIds);

        final records = <Map<String, dynamic>>[];

        // O backend devolve source_local_id. Portanto, os mapas precisam
        // ser indexados por source_local_id e não pelo ID interno da tabela.
        final rowsBySourceLocalId = <String, Map<String, Object?>>{};
        final databaseIdsBySourceLocalId = <String, String>{};

        for (final row in pendingRows) {
          final databaseLocalId = _nullableText(row['id']);

          if (databaseLocalId == null) {
            continue;
          }

          try {
            final payload = _database.prepararPayloadDocumento(row);

            final sourceLocalId = _nullableText(
              payload['source_local_id'],
            );

            if (sourceLocalId == null) {
              rejectedCount++;

              await _database.marcarDocumentoComoFalha(
                localId: databaseLocalId,
                message:
                    'O documento não possui o identificador source_local_id.',
              );

              continue;
            }

            records.add(payload);
            rowsBySourceLocalId[sourceLocalId] = row;
            databaseIdsBySourceLocalId[sourceLocalId] = databaseLocalId;
          } catch (error) {
            rejectedCount++;

            await _database.marcarDocumentoComoFalha(
              localId: databaseLocalId,
              message: 'Documento local inválido: $error',
            );
          }
        }

        if (records.isNotEmpty) {
          final response = await _dio.post<Map<String, dynamic>>(
            '/mobile/sync/documents',
            data: {
              'project_id': projectId,
              'batch_id': const Uuid().v4(),
              'records': records,
            },
          );

          final body = response.data ?? const <String, dynamic>{};

          final accepted = _listMaps(body['accepted']);
          final rejected = _listMaps(body['rejected']);
          final conflicts = _listMaps(body['conflicts']);

          final processedSourceLocalIds = <String>{};

          for (final item in accepted) {
            final sourceLocalId = _nullableText(
              item['source_local_id'],
            );
            final serverId = _nullableText(item['server_id']);
            final syncVersion = _toInt(item['sync_version']);
            final serverUpdatedAt = _toDateTime(
              item['server_updated_at'],
            );

            if (sourceLocalId == null) {
              continue;
            }

            processedSourceLocalIds.add(sourceLocalId);

            final databaseLocalId = databaseIdsBySourceLocalId[sourceLocalId];

            final localRow = rowsBySourceLocalId[sourceLocalId];

            if (databaseLocalId == null || localRow == null) {
              rejectedCount++;
              continue;
            }

            if (serverId == null ||
                syncVersion == null ||
                serverUpdatedAt == null) {
              rejectedCount++;

              await _database.marcarDocumentoComoFalha(
                localId: databaseLocalId,
                message:
                    'A resposta do servidor não contém todos os dados necessários '
                    'para concluir a sincronização.',
              );

              continue;
            }

            await _database.marcarDocumentoComoMetadadosAceitos(
              localId: databaseLocalId,
              syncVersion: syncVersion,
              serverUpdatedAt: serverUpdatedAt,
            );

            final deleted = _toBool(
              localRow['deleted_locally'],
            );

            if (deleted) {
              await _database.marcarDocumentoComoSincronizado(
                localId: databaseLocalId,
                syncVersion: syncVersion,
                serverUpdatedAt: serverUpdatedAt,
              );

              acceptedCount++;
              continue;
            }

            try {
              await _uploadDocumentFile(
                serverId: serverId,
                localRow: localRow,
              );

              await _database.marcarDocumentoComoSincronizado(
                localId: databaseLocalId,
                syncVersion: syncVersion,
                serverUpdatedAt: serverUpdatedAt,
              );

              acceptedCount++;
            } on DioException catch (error) {
              rejectedCount++;

              await _database.marcarDocumentoComoFalha(
                localId: databaseLocalId,
                message: _uploadErrorMessage(error),
              );
            } catch (error) {
              rejectedCount++;

              await _database.marcarDocumentoComoFalha(
                localId: databaseLocalId,
                message: 'Falha ao enviar o arquivo do documento: $error',
              );
            }
          }

          for (final item in rejected) {
            final sourceLocalId = _nullableText(
              item['source_local_id'],
            );

            if (sourceLocalId == null) {
              continue;
            }

            processedSourceLocalIds.add(sourceLocalId);

            final databaseLocalId = databaseIdsBySourceLocalId[sourceLocalId];

            if (databaseLocalId == null) {
              continue;
            }

            rejectedCount++;

            await _database.marcarDocumentoComoFalha(
              localId: databaseLocalId,
              message: _nullableText(item['reason']) ??
                  'Documento rejeitado pelo servidor.',
            );
          }

          for (final item in conflicts) {
            final sourceLocalId = _nullableText(
              item['source_local_id'],
            );
            final currentVersion = _toInt(
              item['current_sync_version'],
            );

            if (sourceLocalId == null || currentVersion == null) {
              continue;
            }

            processedSourceLocalIds.add(sourceLocalId);

            final databaseLocalId = databaseIdsBySourceLocalId[sourceLocalId];

            if (databaseLocalId == null) {
              continue;
            }

            conflictCount++;

            await _database.marcarDocumentoComoConflito(
              localId: databaseLocalId,
              currentSyncVersion: currentVersion,
              message: _nullableText(item['reason']) ??
                  'O documento possui uma versão mais recente no servidor.',
            );
          }

          for (final entry in databaseIdsBySourceLocalId.entries) {
            final sourceLocalId = entry.key;
            final databaseLocalId = entry.value;

            if (processedSourceLocalIds.contains(sourceLocalId)) {
              continue;
            }

            rejectedCount++;

            await _database.marcarDocumentoComoFalha(
              localId: databaseLocalId,
              message: 'O servidor não confirmou o processamento do documento.',
            );
          }
        }
      }

      if (pullAfterPush) {
        pulledCount = await pullRemoteDocuments(
          projectId: projectId,
          limit: 1000,
        );
      }

      return DocumentSyncResult(
        attempted: attempted,
        accepted: acceptedCount,
        rejected: rejectedCount,
        conflicts: conflictCount,
        pulled: pulledCount,
        offline: false,
      );
    } on DioException catch (error) {
      final message = _errorMessage(error);

      for (final row in pendingRows) {
        final databaseLocalId = _nullableText(row['id']);

        if (databaseLocalId == null) {
          continue;
        }

        await _database.marcarDocumentoComoFalha(
          localId: databaseLocalId,
          message: message,
        );
      }

      return DocumentSyncResult(
        attempted: attempted,
        accepted: acceptedCount,
        rejected: pendingRows.isEmpty ? rejectedCount : pendingRows.length,
        conflicts: conflictCount,
        pulled: pulledCount,
        offline: _isOffline(error),
        message: message,
      );
    } catch (error) {
      final message = 'Falha inesperada ao sincronizar documentos: $error';

      for (final row in pendingRows) {
        final databaseLocalId = _nullableText(row['id']);

        if (databaseLocalId == null) {
          continue;
        }

        await _database.marcarDocumentoComoFalha(
          localId: databaseLocalId,
          message: message,
        );
      }

      return DocumentSyncResult(
        attempted: attempted,
        accepted: acceptedCount,
        rejected: pendingRows.isEmpty ? rejectedCount : pendingRows.length,
        conflicts: conflictCount,
        pulled: pulledCount,
        offline: false,
        message: message,
      );
    }
  }

  Future<int> pullRemoteDocuments({
    required String projectId,
    int limit = 1000,
    DateTime? since,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/mobile/sync/documents',
      queryParameters: {
        'project_id': projectId,
        'limit': limit,
        if (since != null) 'since': since.toUtc().toIso8601String(),
      },
    );

    final body = response.data ?? const <String, dynamic>{};
    final records = _listMaps(body['records']);

    if (records.isEmpty) {
      return 0;
    }

    final documents = <RemoteDocumentLocalFile>[];

    for (final record in records) {
      final deleted = _toBool(record['deleted']);

      if (deleted) {
        documents.add(
          RemoteDocumentLocalFile(
            record: record,
          ),
        );

        continue;
      }

      final localId = _nullableText(record['source_local_id']) ??
          _nullableText(record['id']);

      String? existingFilePath;

      if (localId != null) {
        final existing = await _database.buscarDocumentoParaSincronizacao(
            documentId: localId);

        final path = _nullableText(existing?['arquivo_path']);

        if (path != null && await File(path).exists()) {
          existingFilePath = path;
        }
      }

      final localFilePath = existingFilePath ??
          await _downloadRemoteDocument(
            record: record,
          );

      documents.add(
        RemoteDocumentLocalFile(
          record: record,
          localFilePath: localFilePath,
        ),
      );
    }

    await _database.aplicarDocumentosRemotos(
      projectId: projectId,
      documents: documents,
    );

    return documents.length;
  }

  Future<void> _uploadDocumentFile({
    required String serverId,
    required Map<String, Object?> localRow,
  }) async {
    final filePath = _nullableText(localRow['arquivo_path']);

    if (filePath == null) {
      throw StateError(
        'O caminho do arquivo local não foi informado.',
      );
    }

    final file = File(filePath);

    if (!await file.exists()) {
      throw StateError(
        'O arquivo físico não foi encontrado no dispositivo: $filePath',
      );
    }

    final filename = p.basename(filePath);

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      filename: filename,
      contentType: _dioMediaTypeFromPath(filePath),
    );

    final formData = FormData.fromMap({
      'file': multipartFile,
    });

    await _dio.post<void>(
      '/mobile/sync/documents/$serverId/file',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  Future<String> _downloadRemoteDocument({
    required Map<String, dynamic> record,
  }) async {
    final serverId = _nullableText(record['id']);

    if (serverId == null) {
      throw StateError(
        'O documento remoto não possui identificador do servidor.',
      );
    }

    final sealCode =
        _nullableText(record['seal_code']) ?? 'documento_sem_selagem';

    final originalFilename = _nullableText(record['original_filename']);
    final storedFilename = _nullableText(record['stored_filename']);

    final filename = _safeFilename(
      originalFilename ?? storedFilename ?? '$serverId.bin',
    );

    final appDirectory = await getApplicationDocumentsDirectory();

    final targetDirectory = Directory(
      p.join(
        appDirectory.path,
        'documentos_reurb',
        _safeDirectoryName(sealCode),
      ),
    );

    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    final targetPath = p.join(
      targetDirectory.path,
      '${serverId}_$filename',
    );

    final temporaryPath = '$targetPath.part';

    try {
      await _dio.download(
        '/mobile/sync/documents/$serverId/download',
        temporaryPath,
        options: Options(
          responseType: ResponseType.bytes,
        ),
        deleteOnError: true,
      );

      final temporaryFile = File(temporaryPath);

      if (!await temporaryFile.exists()) {
        throw StateError(
          'O download terminou sem criar o arquivo temporário.',
        );
      }

      if (await temporaryFile.length() == 0) {
        await temporaryFile.delete();

        throw StateError(
          'O servidor retornou um arquivo vazio.',
        );
      }

      final targetFile = File(targetPath);

      if (await targetFile.exists()) {
        await targetFile.delete();
      }

      await temporaryFile.rename(targetPath);

      return targetPath;
    } catch (_) {
      final temporaryFile = File(temporaryPath);

      if (await temporaryFile.exists()) {
        await temporaryFile.delete();
      }

      rethrow;
    }
  }

  List<Map<String, dynamic>> _listMaps(Object? value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String? _nullableText(Object? value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  int? _toInt(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  bool _toBool(Object? value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value != 0;
    }

    final normalized = value?.toString().trim().toLowerCase();

    return normalized == '1' ||
        normalized == 'true' ||
        normalized == 'yes' ||
        normalized == 'sim';
  }

  DateTime? _toDateTime(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value.toUtc();
    }

    return DateTime.tryParse(value.toString())?.toUtc();
  }

  bool _isOffline(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }

  String _errorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }

    if (_isOffline(error)) {
      return 'Sem conexão com o servidor. Os documentos permanecem '
          'salvos no aparelho.';
    }

    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return 'A sessão expirou. Entre novamente no aplicativo.';
    }

    if (statusCode == 403) {
      return 'O usuário não possui permissão para sincronizar este projeto.';
    }

    if (statusCode == 413) {
      return 'O arquivo excede o tamanho permitido pelo servidor.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'O servidor está temporariamente indisponível.';
    }

    return 'Não foi possível sincronizar os documentos.';
  }

  String _uploadErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }

    if (_isOffline(error)) {
      return 'Sem conexão durante o envio do arquivo. O documento '
          'permanecerá pendente.';
    }

    switch (error.response?.statusCode) {
      case 400:
        return 'O servidor recusou o arquivo do documento.';
      case 401:
        return 'A sessão expirou durante o envio do documento.';
      case 403:
        return 'O usuário não possui permissão para enviar este documento.';
      case 404:
        return 'O documento não foi encontrado no servidor.';
      case 409:
        return 'O documento foi excluído ou sofreu alteração no servidor.';
      case 413:
        return 'O arquivo excede o tamanho permitido pelo servidor.';
      default:
        return 'Não foi possível enviar o arquivo físico do documento.';
    }
  }

  String _safeFilename(String value) {
    final basename = p.basename(value).trim();

    if (basename.isEmpty) {
      return 'documento.bin';
    }

    return basename.replaceAll(
      RegExp(r'[\\/:*?"<>|]'),
      '_',
    );
  }

  String _safeDirectoryName(String value) {
    final normalized = value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');

    return normalized.isEmpty ? 'sem_selagem' : normalized;
  }

  DioMediaType _dioMediaTypeFromPath(String filePath) {
    final extension = p.extension(filePath).toLowerCase();

    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return DioMediaType('image', 'jpeg');
      case '.png':
        return DioMediaType('image', 'png');
      case '.webp':
        return DioMediaType('image', 'webp');
      case '.pdf':
        return DioMediaType('application', 'pdf');
      case '.doc':
        return DioMediaType('application', 'msword');
      case '.docx':
        return DioMediaType(
          'application',
          'vnd.openxmlformats-officedocument.wordprocessingml.document',
        );
      default:
        return DioMediaType('application', 'octet-stream');
    }
  }
}

class DocumentSyncResult {
  const DocumentSyncResult({
    required this.attempted,
    required this.accepted,
    required this.rejected,
    required this.conflicts,
    required this.pulled,
    required this.offline,
    this.message,
  });

  const DocumentSyncResult.empty()
      : attempted = 0,
        accepted = 0,
        rejected = 0,
        conflicts = 0,
        pulled = 0,
        offline = false,
        message = null;

  final int attempted;
  final int accepted;
  final int rejected;
  final int conflicts;
  final int pulled;
  final bool offline;
  final String? message;
}
