import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Projetos extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get municipio => text()();
  TextColumn get estado => text().withDefault(const Constant('Amapá'))();
  TextColumn get bairro => text()();
  TextColumn get modalidadeReurb => text().nullable()();
  RealColumn get areaHa => real().nullable()();
  IntColumn get lotesEstimados => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('em_execucao'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Lotes extends Table {
  TextColumn get id => text()();
  TextColumn get projetoId => text()();
  TextColumn get codigo => text()();
  TextColumn get quadra => text().nullable()();
  RealColumn get areaM2 => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('pendente'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Beneficiarios extends Table {
  TextColumn get id => text()();
  TextColumn get loteId => text()();
  TextColumn get nomeResponsavel => text()();
  TextColumn get cpf => text().nullable()();
  TextColumn get telefone => text().nullable()();
  TextColumn get statusDocumental => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Selagens extends Table {
  TextColumn get id => text()();
  TextColumn get projetoId => text().nullable()();
  TextColumn get loteId => text().nullable()();
  TextColumn get lotePreliminarId => text().nullable()();
  TextColumn get codigoLotePreliminar => text().nullable()();
  TextColumn get statusVinculoGeografico =>
      text().withDefault(const Constant('nao_validado'))();
  BoolColumn get necessitaValidacaoRtk =>
      boolean().withDefault(const Constant(false))();
  TextColumn get observacaoGeoespacial => text().nullable()();

  TextColumn get codigoSelo => text()();

  TextColumn get situacao => text()();

  BoolColumn get moradorPresente =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get moradiaOcupada =>
      boolean().withDefault(const Constant(true))();

  TextColumn get situacaoAtendimento => text().nullable()();
  TextColumn get tipoUnidade => text().nullable()();
  TextColumn get usoImovel => text().nullable()();

  TextColumn get nomeInformante => text().nullable()();
  TextColumn get telefoneInformante => text().nullable()();
  TextColumn get relacaoInformante => text().nullable()();

  BoolColumn get revisitaNecessaria =>
      boolean().withDefault(const Constant(false))();

  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get precisaoGps => real().nullable()();

  TextColumn get fotoFachadaPath => text().nullable()();
  TextColumn get observacoes => text().nullable()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  TextColumn get serverId => text().nullable()();
  TextColumn get sourceDeviceId => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get syncAttempts => integer().withDefault(const Constant(0))();
  TextColumn get syncError => text().nullable()();
  DateTimeColumn get lastSyncAttemptAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  DateTimeColumn get localUpdatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  BoolColumn get deletedLocally =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class MobileSealCodeReservations extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get deviceId => text()();
  TextColumn get prefix => text()();
  IntColumn get startNumber => integer()();
  IntColumn get endNumber => integer()();
  IntColumn get nextNumber => integer()();
  IntColumn get quantity => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text().withDefault(const Constant('upsert'))();
  TextColumn get projectId => text()();
  TextColumn get payloadJson => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Projetos,
    Lotes,
    Beneficiarios,
    Selagens,
    CadastrosFisicos,
    CadastrosSociais,
    DocumentosReurb,
    LotesPreliminares,
    LotesVetorizadosCidadao,
    MobileSealCodeReservations,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  Future<List<Map<String, Object?>>> listarMapaGeralColeta({
    String? projetoId,
  }) async {
    final filtroTecnico = projetoId == null ? '' : 'WHERE lp.projeto_id = ?';

    final filtroCidadao = projetoId == null ? '' : 'WHERE lv.projeto_id = ?';

    final variables = <Variable>[];

    if (projetoId != null) {
      variables.add(Variable.withString(projetoId));
      variables.add(Variable.withString(projetoId));
    }

    final rows = await customSelect(
      '''
    SELECT *
    FROM (
      SELECT
        lp.id,
        lp.projeto_id,
        lp.codigo_lote,
        lp.quadra,
        lp.area_m2,
        lp.perimetro_m,
        lp.geometria_geojson,
        lp.status_lote AS status,
        lp.necessita_revisao,
        'tecnico' AS origem_vetorizacao,

        p.nome AS projeto_nome,
        p.bairro AS projeto_bairro,
        p.municipio AS projeto_municipio,
        p.estado AS projeto_estado,

        COUNT(DISTINCT s.id) AS total_selagens,
        GROUP_CONCAT(DISTINCT s.codigo_selo) AS codigos_selagem,
        MAX(s.necessita_validacao_rtk) AS necessita_validacao_rtk,
        GROUP_CONCAT(
          DISTINCT s.status_vinculo_geografico
        ) AS status_vinculo_geografico,

        COUNT(DISTINCT cf.id) AS total_cadastros_fisicos,
        COUNT(DISTINCT cs.id) AS total_cadastros_sociais,
        COUNT(DISTINCT d.id) AS total_documentos,

        GROUP_CONCAT(
          DISTINCT cs.nome_responsavel
        ) AS nomes_responsaveis,

        GROUP_CONCAT(
          DISTINCT cs.cpf_responsavel
        ) AS cpfs_responsaveis,

        GROUP_CONCAT(
          DISTINCT cs.telefone
        ) AS telefones_responsaveis

      FROM lotes_preliminares lp

      LEFT JOIN projetos p
        ON p.id = lp.projeto_id

      LEFT JOIN selagens s
        ON s.lote_preliminar_id = lp.id
        OR (
          s.projeto_id = lp.projeto_id
          AND s.codigo_lote_preliminar = lp.codigo_lote
        )

      LEFT JOIN cadastros_fisicos cf
        ON cf.selagem_id = s.id
        OR cf.codigo_selo = s.codigo_selo

      LEFT JOIN cadastros_sociais cs
        ON cs.selagem_id = s.id
        OR cs.codigo_selo = s.codigo_selo

      LEFT JOIN documentos_reurb d
        ON d.selagem_id = s.id
        OR d.codigo_selo = s.codigo_selo
        OR d.cadastro_social_id = cs.id

      $filtroTecnico

      GROUP BY
        lp.id,
        lp.projeto_id,
        lp.codigo_lote,
        lp.quadra,
        lp.area_m2,
        lp.perimetro_m,
        lp.geometria_geojson,
        lp.status_lote,
        lp.necessita_revisao,
        p.nome,
        p.bairro,
        p.municipio,
        p.estado

      UNION ALL

      SELECT
        lv.id,
        lv.projeto_id,
        lv.codigo_lote,
        NULL AS quadra,
        lv.area_m2,
        lv.perimetro_m,
        lv.geometria_geojson,
        lv.status,
        0 AS necessita_revisao,
        'cidadao' AS origem_vetorizacao,

        p.nome AS projeto_nome,
        p.bairro AS projeto_bairro,
        p.municipio AS projeto_municipio,
        p.estado AS projeto_estado,

        CASE
          WHEN lv.selagem_id IS NOT NULL
            OR lv.codigo_selo IS NOT NULL
          THEN 1
          ELSE 0
        END AS total_selagens,

        lv.codigo_selo AS codigos_selagem,

        COALESCE(
          s.necessita_validacao_rtk,
          0
        ) AS necessita_validacao_rtk,

        s.status_vinculo_geografico,

        (
          SELECT COUNT(*)
          FROM cadastros_fisicos cf2
          WHERE cf2.selagem_id = lv.selagem_id
             OR cf2.codigo_selo = lv.codigo_selo
        ) AS total_cadastros_fisicos,

        (
          SELECT COUNT(*)
          FROM cadastros_sociais cs2
          WHERE cs2.id = lv.cadastro_social_id
             OR cs2.selagem_id = lv.selagem_id
             OR cs2.codigo_selo = lv.codigo_selo
        ) AS total_cadastros_sociais,

        (
          SELECT COUNT(*)
          FROM documentos_reurb d2
          WHERE d2.selagem_id = lv.selagem_id
             OR d2.codigo_selo = lv.codigo_selo
             OR d2.cadastro_social_id = lv.cadastro_social_id
        ) AS total_documentos,

        cs.nome_responsavel AS nomes_responsaveis,
        cs.cpf_responsavel AS cpfs_responsaveis,
        cs.telefone AS telefones_responsaveis

      FROM lotes_vetorizados_cidadao lv

      LEFT JOIN projetos p
        ON p.id = lv.projeto_id

      LEFT JOIN selagens s
        ON s.id = lv.selagem_id
        OR s.codigo_selo = lv.codigo_selo

      LEFT JOIN cadastros_sociais cs
        ON cs.id = lv.cadastro_social_id
        OR cs.selagem_id = lv.selagem_id
        OR cs.codigo_selo = lv.codigo_selo

      $filtroCidadao
    )

    ORDER BY
      projeto_bairro ASC,
      origem_vetorizacao ASC,
      codigo_lote ASC
    ''',
      variables: variables,
    ).get();

    return rows.map((row) => row.data).toList();
  }

  int _intFromDb(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  Future<int> _contarRegistrosTabela(String tabela) async {
    final row = await customSelect(
      '''
    SELECT COUNT(*) AS total
    FROM $tabela
    ''',
    ).getSingle();

    return _intFromDb(row.data['total']);
  }

  Future<int> _contarPendentesSync(String tabela) async {
    final row = await customSelect(
      '''
    SELECT COUNT(*) AS total
    FROM $tabela
    WHERE synced = 0
    ''',
    ).getSingle();

    return _intFromDb(row.data['total']);
  }

  Future<Map<String, int>> obterResumoDashboard() async {
    final totalSelagens = await _contarRegistrosTabela('selagens');

    final pendencias = await listarPendenciasValidacao();

    final syncPendentes = await _contarPendentesSync('lotes_preliminares') +
        await _contarPendentesSync('lotes_vetorizados_cidadao') +
        await _contarPendentesSync('selagens') +
        await _contarPendentesSync('cadastros_fisicos') +
        await _contarPendentesSync('cadastros_sociais') +
        await _contarPendentesSync('documentos_reurb');

    return {
      'selagens': totalSelagens,
      'pendencias': pendencias.length,
      'sync': syncPendentes,
    };
  }

  Future<void> marcarRegistrosComoExportados() async {
    await customStatement(
      '''
    UPDATE lotes_preliminares
    SET synced = 1
    WHERE synced = 0
    ''',
    );

    await customStatement(
      '''
UPDATE lotes_vetorizados_cidadao
SET synced = 1
WHERE synced = 0
''',
    );

    await customStatement(
      '''
    UPDATE selagens
    SET synced = 1
    WHERE synced = 0
    ''',
    );

    await customStatement(
      '''
    UPDATE cadastros_fisicos
    SET synced = 1
    WHERE synced = 0
    ''',
    );

    await customStatement(
      '''
    UPDATE cadastros_sociais
    SET synced = 1
    WHERE synced = 0
    ''',
    );

    await customStatement(
      '''
    UPDATE documentos_reurb
    SET synced = 1
    WHERE synced = 0
    ''',
    );
  }

  Future<List<Map<String, Object?>>> listarPendenciasValidacao() async {
    final pendencias = <Map<String, Object?>>[];

    // 1. Selagens sem lote preliminar
    final selagensSemLote = await customSelect(
      '''
    SELECT
      s.id AS referencia_id,
      s.codigo_selo,
      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,
      s.observacao_geoespacial,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    WHERE s.lote_preliminar_id IS NULL
       OR s.codigo_lote_preliminar IS NULL
       OR TRIM(s.codigo_lote_preliminar) = ''
    ORDER BY s.codigo_selo ASC
    ''',
    ).get();

    for (final row in selagensSemLote) {
      pendencias.add({
        'categoria': 'Geoespacial',
        'tipo': 'SELAGEM_SEM_LOTE',
        'criticidade': 'Alta',
        'codigo_selo': row.data['codigo_selo'],
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': null,
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao': 'Selagem sem lote preliminar vinculado.',
        'acao_recomendada':
            'Selecionar lote no mapa ou registrar ocorrência de lote ausente.',
      });
    }

    // 2. Vínculo geoespacial não confirmado
    final vinculosNaoConfirmados = await customSelect(
      '''
    SELECT
      s.id AS referencia_id,
      s.codigo_selo,
      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,
      s.observacao_geoespacial,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    WHERE s.status_vinculo_geografico IS NULL
       OR s.status_vinculo_geografico <> 'confirmado'
    ORDER BY s.codigo_selo ASC
    ''',
    ).get();

    for (final row in vinculosNaoConfirmados) {
      pendencias.add({
        'categoria': 'Geoespacial',
        'tipo': 'VINCULO_NAO_CONFIRMADO',
        'criticidade': 'Média',
        'codigo_selo': row.data['codigo_selo'],
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': null,
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao':
            'Vínculo geoespacial com status: ${row.data['status_vinculo_geografico'] ?? 'não informado'}.',
        'acao_recomendada':
            'Revisar a seleção do lote no mapa e confirmar se o vínculo está correto.',
      });
    }

    // 3. Necessita RTK
    final necessitaRtk = await customSelect(
      '''
    SELECT
      s.id AS referencia_id,
      s.codigo_selo,
      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.observacao_geoespacial,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    WHERE s.necessita_validacao_rtk = 1
    ORDER BY s.codigo_selo ASC
    ''',
    ).get();

    for (final row in necessitaRtk) {
      pendencias.add({
        'categoria': 'Geoespacial',
        'tipo': 'VALIDACAO_RTK',
        'criticidade': 'Alta',
        'codigo_selo': row.data['codigo_selo'],
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': null,
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao': 'Selagem marcada como necessitando validação RTK.',
        'acao_recomendada':
            'Encaminhar para equipe técnica/topográfica realizar validação em campo.',
      });
    }

    // 4. Selagem sem cadastro físico
    final semCadastroFisico = await customSelect(
      '''
    SELECT
      s.id AS referencia_id,
      s.codigo_selo,
      s.codigo_lote_preliminar,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    LEFT JOIN cadastros_fisicos cf
      ON cf.selagem_id = s.id OR cf.codigo_selo = s.codigo_selo
    WHERE cf.id IS NULL
    ORDER BY s.codigo_selo ASC
    ''',
    ).get();

    for (final row in semCadastroFisico) {
      pendencias.add({
        'categoria': 'Cadastro Físico',
        'tipo': 'SEM_CADASTRO_FISICO',
        'criticidade': 'Média',
        'codigo_selo': row.data['codigo_selo'],
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': null,
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao': 'Selagem ainda não possui cadastro físico vinculado.',
        'acao_recomendada':
            'Realizar o cadastro físico do imóvel antes da exportação final.',
      });
    }

    // 5. Selagem sem cadastro social
    final semCadastroSocial = await customSelect(
      '''
    SELECT
      s.id AS referencia_id,
      s.codigo_selo,
      s.codigo_lote_preliminar,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    LEFT JOIN cadastros_sociais cs
      ON cs.selagem_id = s.id OR cs.codigo_selo = s.codigo_selo
    WHERE cs.id IS NULL
    ORDER BY s.codigo_selo ASC
    ''',
    ).get();

    for (final row in semCadastroSocial) {
      pendencias.add({
        'categoria': 'Cadastro Social',
        'tipo': 'SEM_CADASTRO_SOCIAL',
        'criticidade': 'Alta',
        'codigo_selo': row.data['codigo_selo'],
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': null,
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao': 'Selagem ainda não possui cadastro social vinculado.',
        'acao_recomendada':
            'Realizar o cadastro social do responsável familiar.',
      });
    }

    // 6. Cadastro social sem CPF
    final socialSemCpf = await customSelect(
      '''
    SELECT
      cs.id AS referencia_id,
      cs.codigo_selo,
      cs.nome_responsavel,
      s.codigo_lote_preliminar,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM cadastros_sociais cs
    LEFT JOIN selagens s ON s.id = cs.selagem_id
    LEFT JOIN projetos p ON p.id = cs.projeto_id
    WHERE cs.cpf_responsavel IS NULL
       OR TRIM(cs.cpf_responsavel) = ''
    ORDER BY cs.nome_responsavel ASC
    ''',
    ).get();

    for (final row in socialSemCpf) {
      pendencias.add({
        'categoria': 'Cadastro Social',
        'tipo': 'CPF_AUSENTE',
        'criticidade': 'Alta',
        'codigo_selo': row.data['codigo_selo'],
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': row.data['nome_responsavel'],
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao': 'Cadastro social sem CPF informado.',
        'acao_recomendada':
            'Coletar CPF do responsável ou justificar formalmente a ausência.',
      });
    }

    // 7. Cadastro social sem documentos
    final socialSemDocumentos = await customSelect(
      '''
    SELECT
      cs.id AS referencia_id,
      cs.codigo_selo,
      cs.nome_responsavel,
      s.codigo_lote_preliminar,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM cadastros_sociais cs
    LEFT JOIN selagens s ON s.id = cs.selagem_id
    LEFT JOIN projetos p ON p.id = cs.projeto_id
    LEFT JOIN documentos_reurb d
      ON d.cadastro_social_id = cs.id OR d.codigo_selo = cs.codigo_selo
    WHERE d.id IS NULL
    ORDER BY cs.nome_responsavel ASC
    ''',
    ).get();

    for (final row in socialSemDocumentos) {
      pendencias.add({
        'categoria': 'Documentos',
        'tipo': 'SEM_DOCUMENTOS',
        'criticidade': 'Alta',
        'codigo_selo': row.data['codigo_selo'],
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': row.data['nome_responsavel'],
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao': 'Cadastro social sem documentos/fotos anexados.',
        'acao_recomendada':
            'Anexar documentos mínimos do beneficiário e foto da fachada.',
      });
    }

    // 8. Lote preliminar sem selagem
    final lotesSemSelagem = await customSelect(
      '''
    SELECT
      lp.id AS referencia_id,
      lp.codigo_lote,
      lp.quadra,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM lotes_preliminares lp
    LEFT JOIN projetos p ON p.id = lp.projeto_id
    LEFT JOIN selagens s ON s.lote_preliminar_id = lp.id
    WHERE s.id IS NULL
    ORDER BY lp.codigo_lote ASC
    ''',
    ).get();

    for (final row in lotesSemSelagem) {
      pendencias.add({
        'categoria': 'Lotes',
        'tipo': 'LOTE_SEM_SELAGEM',
        'criticidade': 'Média',
        'codigo_selo': null,
        'codigo_lote': row.data['codigo_lote'],
        'responsavel': null,
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao': 'Lote preliminar importado sem selagem realizada.',
        'acao_recomendada':
            'Verificar se o lote está vazio, inacessível, ausente em campo ou pendente de visita.',
      });
    }

    // 9. Lote com mais de uma selagem
    final lotesComMultiplasSelagens = await customSelect(
      '''
    SELECT
      s.lote_preliminar_id AS referencia_id,
      s.codigo_lote_preliminar,
      COUNT(*) AS total,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    WHERE s.lote_preliminar_id IS NOT NULL
    GROUP BY s.lote_preliminar_id, s.codigo_lote_preliminar
    HAVING COUNT(*) > 1
    ORDER BY s.codigo_lote_preliminar ASC
    ''',
    ).get();

    for (final row in lotesComMultiplasSelagens) {
      pendencias.add({
        'categoria': 'Lotes',
        'tipo': 'LOTE_MULTIPLAS_SELAGENS',
        'criticidade': 'Alta',
        'codigo_selo': null,
        'codigo_lote': row.data['codigo_lote_preliminar'],
        'responsavel': null,
        'projeto': row.data['projeto_nome'],
        'bairro': row.data['projeto_bairro'],
        'descricao':
            'Lote possui mais de uma selagem registrada. Total: ${row.data['total']}.',
        'acao_recomendada':
            'Verificar se é duplicidade, coabitação, unidade nos fundos ou subdivisão informal.',
      });
    }

    // 10. CPF duplicado
    final cpfsDuplicados = await customSelect(
      '''
    SELECT
      cs.cpf_responsavel,
      COUNT(*) AS total
    FROM cadastros_sociais cs
    WHERE cs.cpf_responsavel IS NOT NULL
      AND TRIM(cs.cpf_responsavel) <> ''
    GROUP BY cs.cpf_responsavel
    HAVING COUNT(*) > 1
    ORDER BY cs.cpf_responsavel ASC
    ''',
    ).get();

    for (final cpfRow in cpfsDuplicados) {
      final cpf = cpfRow.data['cpf_responsavel']?.toString();

      if (cpf == null || cpf.isEmpty) continue;

      final detalhes = await customSelect(
        '''
      SELECT
        cs.codigo_selo,
        cs.nome_responsavel,
        s.codigo_lote_preliminar,
        p.nome AS projeto_nome,
        p.bairro AS projeto_bairro
      FROM cadastros_sociais cs
      LEFT JOIN selagens s ON s.id = cs.selagem_id
      LEFT JOIN projetos p ON p.id = cs.projeto_id
      WHERE cs.cpf_responsavel = ?
      ORDER BY cs.codigo_selo ASC
      ''',
        variables: [
          Variable.withString(cpf),
        ],
      ).get();

      for (final row in detalhes) {
        pendencias.add({
          'categoria': 'Cadastro Social',
          'tipo': 'CPF_DUPLICADO',
          'criticidade': 'Alta',
          'codigo_selo': row.data['codigo_selo'],
          'codigo_lote': row.data['codigo_lote_preliminar'],
          'responsavel': row.data['nome_responsavel'],
          'projeto': row.data['projeto_nome'],
          'bairro': row.data['projeto_bairro'],
          'descricao': 'CPF duplicado em mais de um cadastro social: $cpf.',
          'acao_recomendada':
              'Verificar se é duplicidade de cadastro ou situação excepcional devidamente justificada.',
        });
      }
    }

    return pendencias;
  }

  Future<void> inserirLotePreliminar({
    required String id,
    required String projetoId,
    required String codigoLote,
    String? quadra,
    double? areaM2,
    double? perimetroM,
    String? geometriaGeojson,
    String? origemArquivo,
    String? tipoGeometria,
    String statusLote = 'preliminar',
    bool necessitaRevisao = false,
    String? observacoes,
  }) async {
    await customStatement(
      '''
    INSERT OR REPLACE INTO lotes_preliminares (
      id,
      projeto_id,
      codigo_lote,
      quadra,
      area_m2,
      perimetro_m,
      geometria_geojson,
      origem_arquivo,
      tipo_geometria,
      status_lote,
      necessita_revisao,
      observacoes,
      synced,
      created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''',
      [
        id,
        projetoId,
        codigoLote,
        quadra,
        areaM2,
        perimetroM,
        geometriaGeojson,
        origemArquivo,
        tipoGeometria,
        statusLote,
        necessitaRevisao ? 1 : 0,
        observacoes,
        0,
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<List<Map<String, Object?>>> listarLotesPreliminares() async {
    final rows = await customSelect(
      '''
    SELECT
      lp.id,
      lp.projeto_id,
      lp.codigo_lote,
      lp.quadra,
      lp.area_m2,
      lp.perimetro_m,
      lp.geometria_geojson,
      lp.origem_arquivo,
      lp.tipo_geometria,
      lp.status_lote,
      lp.necessita_revisao,
      lp.observacoes,
      lp.synced,
      lp.created_at,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM lotes_preliminares lp
    LEFT JOIN projetos p ON p.id = lp.projeto_id
    ORDER BY lp.codigo_lote ASC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarLotesPreliminaresPorProjeto(
    String projetoId,
  ) async {
    final rows = await customSelect(
      '''
    SELECT
      id,
      projeto_id,
      codigo_lote,
      quadra,
      area_m2,
      perimetro_m,
      geometria_geojson,
      origem_arquivo,
      tipo_geometria,
      status_lote,
      necessita_revisao,
      observacoes,
      synced,
      created_at
    FROM lotes_preliminares
    WHERE projeto_id = ?
    ORDER BY codigo_lote ASC
    ''',
      variables: [
        Variable.withString(projetoId),
      ],
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarVetorizacoesLoteCidadaoPorProjeto(
    String projetoId,
  ) async {
    final rows = await customSelect(
      '''
    SELECT
      lv.id,
      lv.projeto_id,
      lv.selagem_id,
      lv.cadastro_social_id,
      lv.codigo_selo,
      lv.codigo_lote,
      lv.origem,
      lv.status,
      lv.geometria_geojson,
      lv.area_m2,
      lv.perimetro_m,
      lv.observacoes,
      lv.print_path,
      lv.synced,
      lv.created_at,
      lv.updated_at,

      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro,
      p.municipio AS projeto_municipio,
      p.estado AS projeto_estado,

      cs.nome_responsavel,
      cs.cpf_responsavel,
      cs.telefone

    FROM lotes_vetorizados_cidadao lv

    LEFT JOIN projetos p
      ON p.id = lv.projeto_id

    LEFT JOIN cadastros_sociais cs
      ON cs.id = lv.cadastro_social_id
      OR cs.codigo_selo = lv.codigo_selo

    WHERE lv.projeto_id = ?

    ORDER BY
      lv.codigo_lote ASC,
      lv.codigo_selo ASC,
      lv.updated_at DESC
    ''',
      variables: [
        Variable.withString(projetoId),
      ],
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<void> excluirTodosLotesPreliminaresDoProjeto(String projetoId) async {
    await customStatement(
      '''
    DELETE FROM lotes_preliminares
    WHERE projeto_id = ?
    ''',
      [projetoId],
    );
  }

  Future<List<Map<String, Object?>>>
      listarConsolidadoGeralParaExportacao() async {
    final rows = await customSelect(
      '''
    SELECT
      s.codigo_selo,
      s.lote_preliminar_id,
s.codigo_lote_preliminar,
s.status_vinculo_geografico,
s.necessita_validacao_rtk,
s.observacao_geoespacial,
      p.nome AS projeto_nome,
      p.municipio,
      p.estado,
      p.bairro,
      s.situacao AS situacao_selagem,
      s.morador_presente,
      s.moradia_ocupada,
      s.situacao_atendimento,
      s.tipo_unidade,
      s.uso_imovel AS uso_imovel_selagem,
      s.nome_informante,
      s.telefone_informante,
      s.relacao_informante,
      s.revisita_necessaria,
      s.latitude,
      s.longitude,
      s.precisao_gps,

      cf.tipo_imovel,
      cf.uso_imovel AS uso_imovel_fisico,
      cf.material_paredes,
      cf.tipo_cobertura,
      cf.tipo_piso,
      cf.numero_pavimentos,
      cf.numero_comodos,
      cf.numero_banheiros,
      cf.possui_energia,
      cf.possui_agua,
      cf.possui_esgoto,
      cf.possui_banheiro,
      cf.condicao_habitabilidade,
      cf.area_risco,
      cf.sujeito_inundacao,

      cs.nome_responsavel,
      cs.cpf_responsavel,
      cs.rg_responsavel,
      cs.orgao_emissor,
      cs.estado_civil,
      cs.profissao,
      cs.telefone,
      cs.quantidade_moradores,
      cs.renda_familiar,
      cs.recebe_programa_social,
      cs.programa_social,
      cs.tempo_ocupacao_anos,
      cs.forma_ocupacao,
      cs.documento_posse,
      cs.possui_outro_imovel,
      cs.possui_conflito,

      (
        SELECT COUNT(*)
        FROM documentos_reurb d
        WHERE d.codigo_selo = s.codigo_selo
      ) AS total_documentos

    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    LEFT JOIN cadastros_fisicos cf ON cf.selagem_id = s.id
    LEFT JOIN cadastros_sociais cs ON cs.selagem_id = s.id
    ORDER BY s.codigo_selo ASC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<void> inserirDocumentoReurb({
    required String id,
    required String projetoId,
    String? selagemId,
    String? cadastroSocialId,
    required String codigoSelo,
    required String tipoDocumento,
    required String arquivoPath,
    String? observacoes,
  }) async {
    await customStatement(
      '''
    INSERT OR REPLACE INTO documentos_reurb (
      id,
      projeto_id,
      selagem_id,
      cadastro_social_id,
      codigo_selo,
      tipo_documento,
      arquivo_path,
      observacoes,
      synced,
      created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''',
      [
        id,
        projetoId,
        selagemId,
        cadastroSocialId,
        codigoSelo,
        tipoDocumento,
        arquivoPath,
        observacoes,
        0,
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<void> atualizarDocumentoReurb({
    required String id,
    required String projetoId,
    String? selagemId,
    String? cadastroSocialId,
    required String codigoSelo,
    required String tipoDocumento,
    required String arquivoPath,
    String? observacoes,
  }) async {
    await customStatement(
      '''
    UPDATE documentos_reurb
    SET
      projeto_id = ?,
      selagem_id = ?,
      cadastro_social_id = ?,
      codigo_selo = ?,
      tipo_documento = ?,
      arquivo_path = ?,
      observacoes = ?,
      synced = 0,
      source_device_id = ?,
      sync_status = 'pending',
      sync_error = NULL,
      local_updated_at = ?,
      deleted_locally = 0
    WHERE id = ?
    ''',
      [
        projetoId,
        selagemId,
        cadastroSocialId,
        codigoSelo,
        tipoDocumento,
        arquivoPath,
        observacoes,
        id,
      ],
    );
  }

  Future<void> excluirDocumentoReurb({
    required String id,
    bool apagarArquivo = true,
  }) async {
    final documento = await customSelect(
      '''
    SELECT arquivo_path
    FROM documentos_reurb
    WHERE id = ?
    ''',
      variables: [
        Variable.withString(id),
      ],
    ).getSingleOrNull();

    if (apagarArquivo && documento != null) {
      final path = documento.data['arquivo_path']?.toString();

      if (path != null && path.trim().isNotEmpty) {
        final file = File(path);

        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    await customStatement(
      '''
    DELETE FROM documentos_reurb
    WHERE id = ?
    ''',
      [id],
    );
  }

  Future<List<Map<String, Object?>>>
      listarCadastrosSociaisParaDocumentos() async {
    final rows = await customSelect(
      '''
    SELECT
      cs.id,
      cs.projeto_id,
      cs.selagem_id,
      cs.codigo_selo,
      cs.nome_responsavel,
      cs.cpf_responsavel,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM cadastros_sociais cs
    LEFT JOIN projetos p ON p.id = cs.projeto_id
    ORDER BY cs.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarDocumentosReurb({
    bool incluirComprovantes = false,
  }) async {
    final whereComprovante = incluirComprovantes
        ? ''
        : "WHERE d.tipo_documento != 'comprovante_selagem'";

    final rows = await customSelect(
      '''
    SELECT
      d.id,
      d.projeto_id,
      d.selagem_id,
      d.cadastro_social_id,
      d.codigo_selo,
      d.tipo_documento,
      d.arquivo_path,
      d.observacoes,
      d.synced,
      d.created_at,
      cs.nome_responsavel,
      cs.cpf_responsavel,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM documentos_reurb d
    LEFT JOIN cadastros_sociais cs ON cs.id = d.cadastro_social_id
    LEFT JOIN projetos p ON p.id = d.projeto_id
    $whereComprovante
    ORDER BY d.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarProjetosParaExportacao() async {
    final rows = await customSelect(
      '''
    SELECT * FROM projetos
    ORDER BY created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarSelagensParaExportacao() async {
    final rows = await customSelect(
      '''
    SELECT * FROM selagens
    ORDER BY created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>>
      listarCadastrosFisicosParaExportacao() async {
    final rows = await customSelect(
      '''
    SELECT * FROM cadastros_fisicos
    ORDER BY created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>>
      listarCadastrosSociaisParaExportacao() async {
    final rows = await customSelect(
      '''
    SELECT * FROM cadastros_sociais
    ORDER BY created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarDocumentosParaExportacao() async {
    final rows = await customSelect(
      '''
    SELECT
      d.id,
      d.projeto_id,
      d.selagem_id,
      d.cadastro_social_id,
      d.codigo_selo,
      d.tipo_documento,
      d.arquivo_path,
      d.observacoes,
      d.synced,
      d.created_at,

      cs.nome_responsavel,
      cs.cpf_responsavel,

      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,

      p.nome AS projeto_nome,
      p.municipio AS projeto_municipio,
      p.estado AS projeto_estado,
      p.bairro AS projeto_bairro

    FROM documentos_reurb d

    LEFT JOIN cadastros_sociais cs
      ON cs.id = d.cadastro_social_id
      OR cs.codigo_selo = d.codigo_selo

    LEFT JOIN selagens s
      ON s.id = d.selagem_id
      OR s.codigo_selo = d.codigo_selo

    LEFT JOIN projetos p
      ON p.id = d.projeto_id

    ORDER BY
      cs.cpf_responsavel ASC,
      d.codigo_selo ASC,
      d.tipo_documento ASC,
      d.created_at ASC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<void> inserirCadastroSocial({
    required String id,
    required String projetoId,
    String? selagemId,
    required String codigoSelo,
    required String nomeResponsavel,
    String? cpfResponsavel,
    String? rgResponsavel,
    String? orgaoEmissor,
    String? estadoCivil,
    String? profissao,
    String? telefone,
    int? quantidadeMoradores,
    double? rendaFamiliar,
    required bool recebeProgramaSocial,
    String? programaSocial,
    int? tempoOcupacaoAnos,
    String? formaOcupacao,
    String? documentoPosse,
    required bool possuiOutroImovel,
    required bool possuiConflito,
    String? observacoes,
  }) async {
    await customStatement(
      '''
    INSERT OR REPLACE INTO cadastros_sociais (
      id,
      projeto_id,
      selagem_id,
      codigo_selo,
      nome_responsavel,
      cpf_responsavel,
      rg_responsavel,
      orgao_emissor,
      estado_civil,
      profissao,
      telefone,
      quantidade_moradores,
      renda_familiar,
      recebe_programa_social,
      programa_social,
      tempo_ocupacao_anos,
      forma_ocupacao,
      documento_posse,
      possui_outro_imovel,
      possui_conflito,
      observacoes,
      synced,
      created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''',
      [
        id,
        projetoId,
        selagemId,
        codigoSelo,
        nomeResponsavel,
        cpfResponsavel,
        rgResponsavel,
        orgaoEmissor,
        estadoCivil,
        profissao,
        telefone,
        quantidadeMoradores,
        rendaFamiliar,
        recebeProgramaSocial ? 1 : 0,
        programaSocial,
        tempoOcupacaoAnos,
        formaOcupacao,
        documentoPosse,
        possuiOutroImovel ? 1 : 0,
        possuiConflito ? 1 : 0,
        observacoes,
        0,
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<void> atualizarCadastroSocial({
    required String id,
    required String projetoId,
    String? selagemId,
    required String codigoSelo,
    required String nomeResponsavel,
    String? cpfResponsavel,
    String? rgResponsavel,
    String? orgaoEmissor,
    String? estadoCivil,
    String? profissao,
    String? telefone,
    int? quantidadeMoradores,
    double? rendaFamiliar,
    required bool recebeProgramaSocial,
    String? programaSocial,
    int? tempoOcupacaoAnos,
    String? formaOcupacao,
    String? documentoPosse,
    required bool possuiOutroImovel,
    required bool possuiConflito,
    String? observacoes,
  }) async {
    await customStatement(
      '''
    UPDATE cadastros_sociais
    SET
      projeto_id = ?,
      selagem_id = ?,
      codigo_selo = ?,
      nome_responsavel = ?,
      cpf_responsavel = ?,
      rg_responsavel = ?,
      orgao_emissor = ?,
      estado_civil = ?,
      profissao = ?,
      telefone = ?,
      quantidade_moradores = ?,
      renda_familiar = ?,
      recebe_programa_social = ?,
      programa_social = ?,
      tempo_ocupacao_anos = ?,
      forma_ocupacao = ?,
      documento_posse = ?,
      possui_outro_imovel = ?,
      possui_conflito = ?,
      observacoes = ?,
      synced = 0
    WHERE id = ?
    ''',
      [
        projetoId,
        selagemId,
        codigoSelo,
        nomeResponsavel,
        cpfResponsavel,
        rgResponsavel,
        orgaoEmissor,
        estadoCivil,
        profissao,
        telefone,
        quantidadeMoradores,
        rendaFamiliar,
        recebeProgramaSocial ? 1 : 0,
        programaSocial,
        tempoOcupacaoAnos,
        formaOcupacao,
        documentoPosse,
        possuiOutroImovel ? 1 : 0,
        possuiConflito ? 1 : 0,
        observacoes,
        id,
      ],
    );
  }

  Future<Map<String, int>> resumoVinculosCadastroSocial({
    required String cadastroSocialId,
    required String codigoSelo,
  }) async {
    final documentos = await customSelect(
      '''
    SELECT COUNT(*) AS total
    FROM documentos_reurb
    WHERE cadastro_social_id = ? OR codigo_selo = ?
    ''',
      variables: [
        Variable.withString(cadastroSocialId),
        Variable.withString(codigoSelo),
      ],
    ).getSingle();

    return {
      'documentos': _intFromDb(documentos.data['total']),
    };
  }

  Future<void> excluirCadastroSocialComDependencias({
    required String cadastroSocialId,
    required String codigoSelo,
    bool apagarArquivos = true,
  }) async {
    final documentos = await customSelect(
      '''
    SELECT arquivo_path
    FROM documentos_reurb
    WHERE cadastro_social_id = ? OR codigo_selo = ?
    ''',
      variables: [
        Variable.withString(cadastroSocialId),
        Variable.withString(codigoSelo),
      ],
    ).get();

    if (apagarArquivos) {
      for (final doc in documentos) {
        final path = doc.data['arquivo_path']?.toString();

        if (path == null || path.trim().isEmpty) {
          continue;
        }

        final file = File(path);

        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    await customStatement(
      '''
    DELETE FROM documentos_reurb
    WHERE cadastro_social_id = ? OR codigo_selo = ?
    ''',
      [
        cadastroSocialId,
        codigoSelo,
      ],
    );

    await customStatement(
      '''
    DELETE FROM cadastros_sociais
    WHERE id = ?
    ''',
      [
        cadastroSocialId,
      ],
    );
  }

  Future<List<Map<String, Object?>>> listarSelagensParaCadastroSocial() async {
    final rows = await customSelect(
      '''
    SELECT
      s.id,
      s.projeto_id,
      s.lote_id,
      s.lote_preliminar_id,
      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,
      s.observacao_geoespacial,
      s.codigo_selo,
      s.situacao,
      s.nome_informante,
      s.telefone_informante,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    ORDER BY s.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarCadastrosSociais() async {
    final rows = await customSelect(
      '''
    SELECT
      cs.id,
      cs.projeto_id,
      cs.selagem_id,
      cs.codigo_selo,
      cs.nome_responsavel,
      cs.cpf_responsavel,
      cs.rg_responsavel,
      cs.orgao_emissor,
      cs.estado_civil,
      cs.profissao,
      cs.telefone,
      cs.quantidade_moradores,
      cs.renda_familiar,
      cs.recebe_programa_social,
      cs.programa_social,
      cs.tempo_ocupacao_anos,
      cs.forma_ocupacao,
      cs.documento_posse,
      cs.possui_outro_imovel,
      cs.possui_conflito,
      cs.observacoes,
      cs.synced,
      cs.created_at,

      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,

      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM cadastros_sociais cs
    LEFT JOIN selagens s ON s.id = cs.selagem_id
    LEFT JOIN projetos p ON p.id = cs.projeto_id
    ORDER BY cs.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>>
      listarCadastrosCompletosParaComprovante() async {
    final rows = await customSelect(
      '''
    SELECT
      cs.id AS cadastro_social_id,
      cs.projeto_id,
      cs.selagem_id,
      cs.codigo_selo,
      cs.nome_responsavel,
      cs.cpf_responsavel,
      cs.rg_responsavel,
      cs.orgao_emissor,
      cs.estado_civil,
      cs.profissao,
      cs.telefone,
      cs.quantidade_moradores,
      cs.renda_familiar,
      cs.recebe_programa_social,
      cs.programa_social,
      cs.tempo_ocupacao_anos,
      cs.forma_ocupacao,
      cs.documento_posse,
      cs.possui_outro_imovel,
      cs.possui_conflito,
      cs.observacoes AS observacoes_sociais,

      s.codigo_lote_preliminar,
      s.situacao AS situacao_selagem,
      s.latitude,
      s.longitude,
      s.precisao_gps,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,

      p.nome AS projeto_nome,
      p.municipio AS projeto_municipio,
      p.estado AS projeto_estado,
      p.bairro AS projeto_bairro,

      cf.id AS cadastro_fisico_id,
      cf.tipo_imovel,
      cf.uso_imovel,
      cf.material_paredes,
      cf.tipo_cobertura,
      cf.tipo_piso,
      cf.numero_pavimentos,
      cf.numero_comodos,
      cf.numero_banheiros,
      cf.possui_energia,
      cf.possui_agua,
      cf.possui_esgoto,
      cf.possui_banheiro,
      cf.condicao_habitabilidade,
      cf.area_risco,
      cf.sujeito_inundacao,
      cf.observacoes AS observacoes_fisicas,

      COUNT(d.id) AS total_documentos,

      GROUP_CONCAT(
        d.tipo_documento || CHAR(31) || IFNULL(d.observacoes, '') || CHAR(31) || d.arquivo_path,
        CHAR(30)
      ) AS documentos_lista,

      CASE
        WHEN cf.id IS NOT NULL THEN 1
        ELSE 0
      END AS cadastro_completo

    FROM cadastros_sociais cs

    LEFT JOIN selagens s 
      ON s.id = cs.selagem_id 
      OR s.codigo_selo = cs.codigo_selo

    LEFT JOIN projetos p 
      ON p.id = cs.projeto_id

    LEFT JOIN cadastros_fisicos cf 
      ON cf.selagem_id = cs.selagem_id 
      OR cf.codigo_selo = cs.codigo_selo

    LEFT JOIN documentos_reurb d 
      ON (
        d.codigo_selo = cs.codigo_selo
        OR d.cadastro_social_id = cs.id
      )
      AND d.tipo_documento != 'comprovante_selagem'

    GROUP BY cs.id

    ORDER BY cs.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>>
      listarSelagensParaVinculoVetorizacao() async {
    final rows = await customSelect(
      '''
    SELECT
      s.id,
      s.projeto_id,
      s.codigo_selo,
      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.latitude,
      s.longitude,
      s.precisao_gps,
      s.created_at,

      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro,
      p.municipio AS projeto_municipio,
      p.estado AS projeto_estado,

      cs.id AS cadastro_social_id,
      cs.nome_responsavel,
      cs.cpf_responsavel,
      cs.telefone

    FROM selagens s

    LEFT JOIN projetos p
      ON p.id = s.projeto_id

    LEFT JOIN cadastros_sociais cs
      ON cs.codigo_selo = s.codigo_selo

    ORDER BY
      s.created_at DESC,
      s.codigo_selo ASC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<void> salvarVetorizacaoLoteCidadao({
    required String id,
    String? projetoId,
    String? selagemId,
    String? cadastroSocialId,
    String? codigoSelo,
    String? codigoLote,
    required String geometriaGeojson,
    required double areaM2,
    required double perimetroM,
    String origem = 'cidadao_assistido',
    String status = 'rascunho',
    String? observacoes,
    String? printPath,
  }) async {
    await customStatement(
      '''
    INSERT INTO lotes_vetorizados_cidadao (
      id,
      projeto_id,
      selagem_id,
      cadastro_social_id,
      codigo_selo,
      codigo_lote,
      origem,
      status,
      geometria_geojson,
      area_m2,
      perimetro_m,
      observacoes,
      print_path,
      synced,
      created_at,
      updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      projeto_id = excluded.projeto_id,
      selagem_id = excluded.selagem_id,
      cadastro_social_id = excluded.cadastro_social_id,
      codigo_selo = excluded.codigo_selo,
      codigo_lote = excluded.codigo_lote,
      origem = excluded.origem,
      status = excluded.status,
      geometria_geojson = excluded.geometria_geojson,
      area_m2 = excluded.area_m2,
      perimetro_m = excluded.perimetro_m,
      observacoes = excluded.observacoes,
      print_path = excluded.print_path,
      synced = 0,
      updated_at = excluded.updated_at
    ''',
      [
        id,
        projetoId,
        selagemId,
        cadastroSocialId,
        codigoSelo,
        codigoLote,
        origem,
        status,
        geometriaGeojson,
        areaM2,
        perimetroM,
        observacoes,
        printPath,
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<Map<String, Object?>?> buscarVetorizacaoLoteCidadao({
    String? id,
    String? codigoSelo,
    String? codigoLote,
  }) async {
    final whereParts = <String>[];
    final variables = <Variable>[];

    if (id != null && id.trim().isNotEmpty) {
      whereParts.add('id = ?');
      variables.add(Variable<String>(id));
    }

    if (codigoSelo != null && codigoSelo.trim().isNotEmpty) {
      whereParts.add('codigo_selo = ?');
      variables.add(Variable<String>(codigoSelo));
    }

    if (codigoLote != null && codigoLote.trim().isNotEmpty) {
      whereParts.add('codigo_lote = ?');
      variables.add(Variable<String>(codigoLote));
    }

    final whereSql = whereParts.isEmpty
        ? '1 = 1'
        : whereParts.map((item) => '($item)').join(' OR ');

    final rows = await customSelect(
      '''
    SELECT *
    FROM lotes_vetorizados_cidadao
    WHERE $whereSql
    ORDER BY updated_at DESC
    LIMIT 1
    ''',
      variables: variables,
    ).get();

    if (rows.isEmpty) return null;

    return rows.first.data;
  }

  Future<List<Map<String, Object?>>>
      listarVetorizacoesLoteCidadaoParaMapa() async {
    final rows = await customSelect(
      '''
    SELECT
      lv.id,
      lv.projeto_id,
      lv.selagem_id,
      lv.cadastro_social_id,
      lv.codigo_selo,
      lv.codigo_lote,
      lv.origem,
      lv.status,
      lv.geometria_geojson,
      lv.area_m2,
      lv.perimetro_m,
      lv.observacoes,
      lv.print_path,
      lv.synced,
      lv.created_at,
      lv.updated_at,

      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro,
      p.municipio AS projeto_municipio,
      p.estado AS projeto_estado,

      s.codigo_lote_preliminar,

      cs.nome_responsavel,
      cs.cpf_responsavel,
      cs.telefone

    FROM lotes_vetorizados_cidadao lv

    LEFT JOIN projetos p 
      ON p.id = lv.projeto_id

    LEFT JOIN selagens s
      ON s.id = lv.selagem_id
      OR s.codigo_selo = lv.codigo_selo

    LEFT JOIN cadastros_sociais cs
      ON cs.id = lv.cadastro_social_id
      OR cs.codigo_selo = lv.codigo_selo

    ORDER BY lv.updated_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>>
      listarVetorizacoesLoteCidadaoParaExportacao() async {
    final rows = await customSelect(
      '''
    SELECT *
    FROM lotes_vetorizados_cidadao
    ORDER BY updated_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  @override
  int get schemaVersion => 11;

  Future<void> inserirCadastroFisico({
    required String id,
    required String projetoId,
    String? selagemId,
    required String codigoSelo,
    String? tipoImovel,
    String? usoImovel,
    String? materialParedes,
    String? tipoCobertura,
    String? tipoPiso,
    int? numeroPavimentos,
    int? numeroComodos,
    int? numeroBanheiros,
    required bool possuiEnergia,
    required bool possuiAgua,
    required bool possuiEsgoto,
    required bool possuiBanheiro,
    String? condicaoHabitabilidade,
    required bool areaRisco,
    required bool sujeitoInundacao,
    String? observacoes,
  }) async {
    await customStatement(
      '''
    INSERT OR REPLACE INTO cadastros_fisicos (
      id,
      projeto_id,
      selagem_id,
      codigo_selo,
      tipo_imovel,
      uso_imovel,
      material_paredes,
      tipo_cobertura,
      tipo_piso,
      numero_pavimentos,
      numero_comodos,
      numero_banheiros,
      possui_energia,
      possui_agua,
      possui_esgoto,
      possui_banheiro,
      condicao_habitabilidade,
      area_risco,
      sujeito_inundacao,
      observacoes,
      synced,
      created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''',
      [
        id,
        projetoId,
        selagemId,
        codigoSelo,
        tipoImovel,
        usoImovel,
        materialParedes,
        tipoCobertura,
        tipoPiso,
        numeroPavimentos,
        numeroComodos,
        numeroBanheiros,
        possuiEnergia ? 1 : 0,
        possuiAgua ? 1 : 0,
        possuiEsgoto ? 1 : 0,
        possuiBanheiro ? 1 : 0,
        condicaoHabitabilidade,
        areaRisco ? 1 : 0,
        sujeitoInundacao ? 1 : 0,
        observacoes,
        0,
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<void> atualizarCadastroFisico({
    required String id,
    required String projetoId,
    String? selagemId,
    required String codigoSelo,
    String? tipoImovel,
    String? usoImovel,
    String? materialParedes,
    String? tipoCobertura,
    String? tipoPiso,
    int? numeroPavimentos,
    int? numeroComodos,
    int? numeroBanheiros,
    required bool possuiEnergia,
    required bool possuiAgua,
    required bool possuiEsgoto,
    required bool possuiBanheiro,
    String? condicaoHabitabilidade,
    required bool areaRisco,
    required bool sujeitoInundacao,
    String? observacoes,
  }) async {
    await customStatement(
      '''
    UPDATE cadastros_fisicos
    SET
      projeto_id = ?,
      selagem_id = ?,
      codigo_selo = ?,
      tipo_imovel = ?,
      uso_imovel = ?,
      material_paredes = ?,
      tipo_cobertura = ?,
      tipo_piso = ?,
      numero_pavimentos = ?,
      numero_comodos = ?,
      numero_banheiros = ?,
      possui_energia = ?,
      possui_agua = ?,
      possui_esgoto = ?,
      possui_banheiro = ?,
      condicao_habitabilidade = ?,
      area_risco = ?,
      sujeito_inundacao = ?,
      observacoes = ?,
      synced = 0
    WHERE id = ?
    ''',
      [
        projetoId,
        selagemId,
        codigoSelo,
        tipoImovel,
        usoImovel,
        materialParedes,
        tipoCobertura,
        tipoPiso,
        numeroPavimentos,
        numeroComodos,
        numeroBanheiros,
        possuiEnergia ? 1 : 0,
        possuiAgua ? 1 : 0,
        possuiEsgoto ? 1 : 0,
        possuiBanheiro ? 1 : 0,
        condicaoHabitabilidade,
        areaRisco ? 1 : 0,
        sujeitoInundacao ? 1 : 0,
        observacoes,
        id,
      ],
    );
  }

  Future<void> excluirCadastroFisico(String id) async {
    await customStatement(
      '''
    DELETE FROM cadastros_fisicos
    WHERE id = ?
    ''',
      [id],
    );
  }

  Future<List<Map<String, Object?>>> listarSelagensParaCadastroFisico() async {
    final rows = await customSelect(
      '''
    SELECT
      s.id,
      s.projeto_id,
      s.lote_id,
      s.lote_preliminar_id,
      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,
      s.observacao_geoespacial,
      s.codigo_selo,
      s.situacao,
      s.tipo_unidade,
      s.uso_imovel,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    ORDER BY s.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarCadastrosFisicos() async {
    final rows = await customSelect(
      '''
    SELECT
      cf.id,
      cf.projeto_id,
      cf.selagem_id,
      cf.codigo_selo,
      cf.tipo_imovel,
      cf.uso_imovel,
      cf.material_paredes,
      cf.tipo_cobertura,
      cf.tipo_piso,
      cf.numero_pavimentos,
      cf.numero_comodos,
      cf.numero_banheiros,
      cf.possui_energia,
      cf.possui_agua,
      cf.possui_esgoto,
      cf.possui_banheiro,
      cf.condicao_habitabilidade,
      cf.area_risco,
      cf.sujeito_inundacao,
      cf.observacoes,
      cf.synced,
      cf.created_at,

      s.codigo_lote_preliminar,
      s.status_vinculo_geografico,
      s.necessita_validacao_rtk,

      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM cadastros_fisicos cf
    LEFT JOIN selagens s ON s.id = cf.selagem_id
    LEFT JOIN projetos p ON p.id = cf.projeto_id
    ORDER BY cf.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await customStatement(
            "ALTER TABLE projetos ADD COLUMN estado TEXT NOT NULL DEFAULT 'Amapá'",
          );
          await customStatement(
            "ALTER TABLE projetos ADD COLUMN area_ha REAL",
          );
          await customStatement(
            "ALTER TABLE projetos ADD COLUMN lotes_estimados INTEGER",
          );
          await customStatement(
            "ALTER TABLE projetos ADD COLUMN status TEXT NOT NULL DEFAULT 'em_execucao'",
          );
        }

        if (from < 3) {
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN projeto_id TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN observacoes TEXT",
          );
        }
        if (from < 4) {
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN morador_presente INTEGER NOT NULL DEFAULT 0",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN moradia_ocupada INTEGER NOT NULL DEFAULT 1",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN situacao_atendimento TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN tipo_unidade TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN uso_imovel TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN nome_informante TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN telefone_informante TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN relacao_informante TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN revisita_necessaria INTEGER NOT NULL DEFAULT 0",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN precisao_gps REAL",
          );
        }
        if (from < 5) {
          await m.createTable(cadastrosFisicos);
        }
        if (from < 6) {
          await m.createTable(cadastrosSociais);
        }
        if (from < 7) {
          await m.createTable(documentosReurb);
        }
        if (from < 8) {
          await m.createTable(lotesPreliminares);
        }
        if (from < 9) {
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN lote_preliminar_id TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN codigo_lote_preliminar TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN status_vinculo_geografico TEXT NOT NULL DEFAULT 'nao_validado'",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN necessita_validacao_rtk INTEGER NOT NULL DEFAULT 0",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN observacao_geoespacial TEXT",
          );
        }
        if (from < 10) {
          await m.createTable(lotesVetorizadosCidadao);
        }

        if (from < 11) {
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN server_id TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN source_device_id TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN sync_status TEXT NOT NULL DEFAULT 'pending'",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN sync_attempts INTEGER NOT NULL DEFAULT 0",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN sync_error TEXT",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN last_sync_attempt_at INTEGER",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN synced_at INTEGER",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN local_updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now'))",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN server_updated_at INTEGER",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN sync_version INTEGER NOT NULL DEFAULT 1",
          );
          await customStatement(
            "ALTER TABLE selagens ADD COLUMN deleted_locally INTEGER NOT NULL DEFAULT 0",
          );

          await m.createTable(mobileSealCodeReservations);
          await m.createTable(syncQueue);
        }
      },
    );
  }

  Future<void> atualizarSelagemReurb({
    required String id,
    required String projetoId,
    String? loteId,
    String? lotePreliminarId,
    String? codigoLotePreliminar,
    required String codigoSelo,
    required String situacao,
    required bool moradorPresente,
    required bool moradiaOcupada,
    String? situacaoAtendimento,
    String? tipoUnidade,
    String? usoImovel,
    String? nomeInformante,
    String? telefoneInformante,
    String? relacaoInformante,
    required bool revisitaNecessaria,
    String statusVinculoGeografico = 'nao_validado',
    bool necessitaValidacaoRtk = false,
    String? observacaoGeoespacial,
    double? latitude,
    double? longitude,
    double? precisaoGps,
    String? fotoFachadaPath,
    String? observacoes,
    required String sourceDeviceId,
  }) async {
    final now = DateTime.now().toIso8601String();

    await customStatement(
      '''
      UPDATE selagens
      SET
        projeto_id = ?,
        lote_id = ?,
        lote_preliminar_id = ?,
        codigo_lote_preliminar = ?,
        status_vinculo_geografico = ?,
        necessita_validacao_rtk = ?,
        observacao_geoespacial = ?,
        codigo_selo = ?,
        situacao = ?,
        morador_presente = ?,
        moradia_ocupada = ?,
        situacao_atendimento = ?,
        tipo_unidade = ?,
        uso_imovel = ?,
        nome_informante = ?,
        telefone_informante = ?,
        relacao_informante = ?,
        revisita_necessaria = ?,
        latitude = ?,
        longitude = ?,
        precisao_gps = ?,
        foto_fachada_path = ?,
        observacoes = ?,
        synced = 0,
        source_device_id = ?,
        sync_status = 'pending',
        sync_error = NULL,
        sync_attempts = 0,
        local_updated_at = ?
      WHERE id = ?
      ''',
      [
        projetoId,
        loteId,
        lotePreliminarId,
        codigoLotePreliminar,
        statusVinculoGeografico,
        necessitaValidacaoRtk ? 1 : 0,
        observacaoGeoespacial,
        codigoSelo,
        situacao,
        moradorPresente ? 1 : 0,
        moradiaOcupada ? 1 : 0,
        situacaoAtendimento,
        tipoUnidade,
        usoImovel,
        nomeInformante,
        telefoneInformante,
        relacaoInformante,
        revisitaNecessaria ? 1 : 0,
        latitude,
        longitude,
        precisaoGps,
        fotoFachadaPath,
        observacoes,
        sourceDeviceId,
        now,
        id,
      ],
    );

    await enfileirarSincronizacao(
      entityType: 'seal',
      entityId: id,
      projectId: projetoId,
      operation: 'upsert',
    );
  }

  Future<Map<String, int>> resumoVinculosSelagem({
    required String selagemId,
    required String codigoSelo,
  }) async {
    final fisicos = await customSelect(
      '''
    SELECT COUNT(*) AS total
    FROM cadastros_fisicos
    WHERE selagem_id = ? OR codigo_selo = ?
    ''',
      variables: [
        Variable.withString(selagemId),
        Variable.withString(codigoSelo),
      ],
    ).getSingle();

    final sociais = await customSelect(
      '''
    SELECT COUNT(*) AS total
    FROM cadastros_sociais
    WHERE selagem_id = ? OR codigo_selo = ?
    ''',
      variables: [
        Variable.withString(selagemId),
        Variable.withString(codigoSelo),
      ],
    ).getSingle();

    final documentos = await customSelect(
      '''
    SELECT COUNT(*) AS total
    FROM documentos_reurb
    WHERE selagem_id = ? OR codigo_selo = ?
    ''',
      variables: [
        Variable.withString(selagemId),
        Variable.withString(codigoSelo),
      ],
    ).getSingle();

    return {
      'cadastros_fisicos': fisicos.data['total'] as int? ?? 0,
      'cadastros_sociais': sociais.data['total'] as int? ?? 0,
      'documentos': documentos.data['total'] as int? ?? 0,
    };
  }

  Future<void> excluirSelagemComDependencias({
    required String selagemId,
    required String codigoSelo,
    bool apagarArquivos = true,
  }) async {
    final documentos = await customSelect(
      '''
    SELECT arquivo_path
    FROM documentos_reurb
    WHERE selagem_id = ? OR codigo_selo = ?
    ''',
      variables: [
        Variable.withString(selagemId),
        Variable.withString(codigoSelo),
      ],
    ).get();

    if (apagarArquivos) {
      for (final doc in documentos) {
        final path = doc.data['arquivo_path']?.toString();

        if (path == null || path.trim().isEmpty) {
          continue;
        }

        final file = File(path);

        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    await customStatement(
      '''
    DELETE FROM documentos_reurb
    WHERE selagem_id = ? OR codigo_selo = ?
    ''',
      [
        selagemId,
        codigoSelo,
      ],
    );

    await customStatement(
      '''
    DELETE FROM cadastros_sociais
    WHERE selagem_id = ? OR codigo_selo = ?
    ''',
      [
        selagemId,
        codigoSelo,
      ],
    );

    await customStatement(
      '''
    DELETE FROM cadastros_fisicos
    WHERE selagem_id = ? OR codigo_selo = ?
    ''',
      [
        selagemId,
        codigoSelo,
      ],
    );

    await customStatement(
      '''
    DELETE FROM selagens
    WHERE id = ?
    ''',
      [
        selagemId,
      ],
    );
  }

  Future<void> excluirSelagemReurb(String id) async {
    await customStatement(
      '''
    DELETE FROM selagens
    WHERE id = ?
    ''',
      [id],
    );
  }

  Future<String> gerarProximoCodigoSelagem({
    required String projetoId,
    required String prefixo,
  }) async {
    final rows = await customSelect(
      '''
    SELECT codigo_selo
    FROM selagens
    WHERE projeto_id = ?
    ORDER BY created_at ASC
    ''',
      variables: [
        Variable.withString(projetoId),
      ],
    ).get();

    var maiorNumero = 0;

    for (final row in rows) {
      final codigo = row.data['codigo_selo']?.toString() ?? '';
      final partes = codigo.split('-');

      if (partes.length == 2) {
        final numero = int.tryParse(partes.last) ?? 0;
        if (numero > maiorNumero) {
          maiorNumero = numero;
        }
      }
    }

    final proximo = maiorNumero + 1;
    return '$prefixo-${proximo.toString().padLeft(4, '0')}';
  }

  Future<void> inserirSelagemReurb({
    required String id,
    required String projetoId,
    String? loteId,
    String? lotePreliminarId,
    String? codigoLotePreliminar,
    required String codigoSelo,
    required String situacao,
    required bool moradorPresente,
    required bool moradiaOcupada,
    String? situacaoAtendimento,
    String? tipoUnidade,
    String? usoImovel,
    String? nomeInformante,
    String? telefoneInformante,
    String? relacaoInformante,
    required bool revisitaNecessaria,
    String statusVinculoGeografico = 'nao_validado',
    bool necessitaValidacaoRtk = false,
    String? observacaoGeoespacial,
    double? latitude,
    double? longitude,
    double? precisaoGps,
    String? fotoFachadaPath,
    String? observacoes,
    required String sourceDeviceId,
  }) async {
    await customStatement(
      '''
  INSERT OR REPLACE INTO selagens (
    id,
    projeto_id,
    lote_id,
    lote_preliminar_id,
    codigo_lote_preliminar,
    status_vinculo_geografico,
    necessita_validacao_rtk,
    observacao_geoespacial,
    codigo_selo,
    situacao,
    morador_presente,
    moradia_ocupada,
    situacao_atendimento,
    tipo_unidade,
    uso_imovel,
    nome_informante,
    telefone_informante,
    relacao_informante,
    revisita_necessaria,
    latitude,
    longitude,
    precisao_gps,
    foto_fachada_path,
    observacoes,
    synced,
    server_id,
    source_device_id,
    sync_status,
    sync_attempts,
    sync_version,
    deleted_locally,
    local_updated_at,
    created_at
  ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''',
      [
        id,
        projetoId,
        loteId,
        lotePreliminarId,
        codigoLotePreliminar,
        statusVinculoGeografico,
        necessitaValidacaoRtk ? 1 : 0,
        observacaoGeoespacial,
        codigoSelo,
        situacao,
        moradorPresente ? 1 : 0,
        moradiaOcupada ? 1 : 0,
        situacaoAtendimento,
        tipoUnidade,
        usoImovel,
        nomeInformante,
        telefoneInformante,
        relacaoInformante,
        revisitaNecessaria ? 1 : 0,
        latitude,
        longitude,
        precisaoGps,
        fotoFachadaPath,
        observacoes,
        0,
        null,
        sourceDeviceId,
        'pending',
        0,
        1,
        0,
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String(),
      ],
    );

    await enfileirarSincronizacao(
      entityType: 'seal',
      entityId: id,
      projectId: projetoId,
      operation: 'upsert',
    );
  }

  Future<List<Map<String, Object?>>> listarSelagensReurb() async {
    final rows = await customSelect(
      '''
    SELECT
      s.id,
      s.projeto_id,
      s.lote_id,
      s.lote_preliminar_id,
s.codigo_lote_preliminar,
s.status_vinculo_geografico,
s.necessita_validacao_rtk,
s.observacao_geoespacial,
      s.codigo_selo,
      s.situacao,
      s.morador_presente,
      s.moradia_ocupada,
      s.situacao_atendimento,
      s.tipo_unidade,
      s.uso_imovel,
      s.nome_informante,
      s.telefone_informante,
      s.relacao_informante,
      s.revisita_necessaria,
      s.latitude,
      s.longitude,
      s.precisao_gps,
      s.foto_fachada_path,
      s.observacoes,
      s.synced,
      s.server_id,
      s.source_device_id,
      s.sync_status,
      s.sync_attempts,
      s.sync_error,
      s.last_sync_attempt_at,
      s.synced_at,
      s.local_updated_at,
      s.server_updated_at,
      s.sync_version,
      s.deleted_locally,
      s.created_at,
      p.nome AS projeto_nome,
      p.bairro AS projeto_bairro
    FROM selagens s
    LEFT JOIN projetos p ON p.id = s.projeto_id
    ORDER BY s.created_at DESC
    ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<void> inserirProjetoReurb({
    required String id,
    required String nome,
    required String municipio,
    required String estado,
    required String bairro,
    required String modalidadeReurb,
    required double areaHa,
    required int lotesEstimados,
    required String status,
  }) async {
    await customStatement(
      '''
      INSERT OR REPLACE INTO projetos (
        id,
        nome,
        municipio,
        estado,
        bairro,
        modalidade_reurb,
        area_ha,
        lotes_estimados,
        status,
        created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        id,
        nome,
        municipio,
        estado,
        bairro,
        modalidadeReurb,
        areaHa,
        lotesEstimados,
        status,
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<void> atualizarProjetoReurb({
    required String id,
    required String nome,
    required String municipio,
    required String estado,
    required String bairro,
    required String modalidadeReurb,
    required double areaHa,
    required int lotesEstimados,
    required String status,
  }) async {
    await customStatement(
      '''
    UPDATE projetos
    SET
      nome = ?,
      municipio = ?,
      estado = ?,
      bairro = ?,
      modalidade_reurb = ?,
      area_ha = ?,
      lotes_estimados = ?,
      status = ?
    WHERE id = ?
    ''',
      [
        nome,
        municipio,
        estado,
        bairro,
        modalidadeReurb,
        areaHa,
        lotesEstimados,
        status,
        id,
      ],
    );
  }

  Future<void> excluirProjetoReurb(String id) async {
    await customStatement(
      '''
    DELETE FROM projetos
    WHERE id = ?
    ''',
      [id],
    );
  }

  Future<void> upsertProjetoAutorizado({
    required String id,
    required String nome,
    required String municipio,
    required String estado,
    required String bairro,
    required String modalidadeReurb,
    required String status,
  }) async {
    await customStatement(
      '''
      INSERT INTO projetos (
        id,
        nome,
        municipio,
        estado,
        bairro,
        modalidade_reurb,
        status,
        created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        nome = excluded.nome,
        municipio = excluded.municipio,
        estado = excluded.estado,
        bairro = excluded.bairro,
        modalidade_reurb = excluded.modalidade_reurb,
        status = excluded.status
      ''',
      [
        id,
        nome,
        municipio,
        estado,
        bairro,
        modalidadeReurb,
        status,
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<void> salvarReservaCodigosSelagem({
    required String id,
    required String projectId,
    required String deviceId,
    required String prefix,
    required int startNumber,
    required int endNumber,
    required int nextNumber,
    required int quantity,
    DateTime? expiresAt,
  }) async {
    await customStatement(
      '''
      INSERT OR REPLACE INTO mobile_seal_code_reservations (
        id,
        project_id,
        device_id,
        prefix,
        start_number,
        end_number,
        next_number,
        quantity,
        active,
        expires_at,
        created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?)
      ''',
      [
        id,
        projectId,
        deviceId,
        prefix,
        startNumber,
        endNumber,
        nextNumber,
        quantity,
        expiresAt?.toIso8601String(),
        DateTime.now().toIso8601String(),
      ],
    );
  }

  Future<String?> consumirProximoCodigoReservado({
    required String projectId,
    required String deviceId,
  }) async {
    return transaction(() async {
      final row = await customSelect(
        '''
        SELECT *
        FROM mobile_seal_code_reservations
        WHERE project_id = ?
          AND device_id = ?
          AND active = 1
          AND next_number <= end_number
        ORDER BY created_at ASC
        LIMIT 1
        ''',
        variables: [
          Variable.withString(projectId),
          Variable.withString(deviceId),
        ],
      ).getSingleOrNull();

      if (row == null) return null;

      final prefix = row.data['prefix']?.toString() ?? 'RE';
      final current = row.data['next_number'] as int;
      final end = row.data['end_number'] as int;
      final next = current + 1;

      await customStatement(
        '''
        UPDATE mobile_seal_code_reservations
        SET
          next_number = ?,
          active = ?
        WHERE id = ?
        ''',
        [
          next,
          next <= end ? 1 : 0,
          row.data['id'],
        ],
      );

      return '$prefix-${current.toString().padLeft(6, '0')}';
    });
  }

  Future<void> enfileirarSincronizacao({
    required String entityType,
    required String entityId,
    required String projectId,
    String operation = 'upsert',
    String? payloadJson,
  }) async {
    final queueId = '$entityType:$entityId';
    final now = DateTime.now().toIso8601String();

    await customStatement(
      '''
      INSERT INTO sync_queue (
        id,
        entity_type,
        entity_id,
        operation,
        project_id,
        payload_json,
        status,
        attempts,
        last_error,
        next_attempt_at,
        created_at,
        updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, 'pending', 0, NULL, NULL, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        operation = excluded.operation,
        project_id = excluded.project_id,
        payload_json = excluded.payload_json,
        status = 'pending',
        last_error = NULL,
        next_attempt_at = NULL,
        updated_at = excluded.updated_at
      ''',
      [
        queueId,
        entityType,
        entityId,
        operation,
        projectId,
        payloadJson,
        now,
        now,
      ],
    );
  }

  Future<List<Map<String, Object?>>> listarFilaPendente({
    String entityType = 'seal',
    int limit = 100,
  }) async {
    final rows = await customSelect(
      '''
      SELECT *
      FROM sync_queue
      WHERE entity_type = ?
        AND status IN ('pending', 'failed')
        AND (
          next_attempt_at IS NULL
          OR next_attempt_at <= ?
        )
      ORDER BY created_at ASC
      LIMIT ?
      ''',
      variables: [
        Variable.withString(entityType),
        Variable.withDateTime(DateTime.now()),
        Variable.withInt(limit),
      ],
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<Map<String, Object?>?> buscarSelagemPorId(String id) async {
    final row = await customSelect(
      '''
      SELECT *
      FROM selagens
      WHERE id = ?
      LIMIT 1
      ''',
      variables: [Variable.withString(id)],
    ).getSingleOrNull();

    return row?.data;
  }

  Future<int> contarSelagensPendentes() async {
    final row = await customSelect(
      '''
      SELECT COUNT(*) AS total
      FROM selagens
      WHERE sync_status IN ('pending', 'failed', 'conflict')
      ''',
    ).getSingle();

    return row.data['total'] as int? ?? 0;
  }

  Future<void> marcarFilaComoSincronizando(
    List<String> queueIds,
  ) async {
    if (queueIds.isEmpty) return;

    await transaction(() async {
      final now = DateTime.now().toIso8601String();

      for (final queueId in queueIds) {
        await customStatement(
          '''
          UPDATE sync_queue
          SET
            status = 'syncing',
            attempts = attempts + 1,
            last_error = NULL,
            updated_at = ?
          WHERE id = ?
          ''',
          [now, queueId],
        );
      }
    });
  }

  Future<void> marcarSelagemComoSincronizada({
    required String localId,
    required String serverId,
    required int syncVersion,
    required DateTime serverUpdatedAt,
  }) async {
    await transaction(() async {
      final now = DateTime.now().toIso8601String();

      await customStatement(
        '''
        UPDATE selagens
        SET
          synced = 1,
          server_id = ?,
          sync_status = 'synced',
          sync_error = NULL,
          synced_at = ?,
          server_updated_at = ?,
          sync_version = ?,
          local_updated_at = ?
        WHERE id = ?
        ''',
        [
          serverId,
          now,
          serverUpdatedAt.toIso8601String(),
          syncVersion,
          now,
          localId,
        ],
      );

      await customStatement(
        'DELETE FROM sync_queue WHERE id = ?',
        ['seal:$localId'],
      );
    });
  }

  Future<void> marcarSelagemComoFalha({
    required String localId,
    required String message,
    Duration retryAfter = const Duration(minutes: 1),
  }) async {
    await transaction(() async {
      final now = DateTime.now();
      final nextAttempt = now.add(retryAfter);

      await customStatement(
        '''
        UPDATE selagens
        SET
          synced = 0,
          sync_status = 'failed',
          sync_error = ?,
          sync_attempts = sync_attempts + 1,
          last_sync_attempt_at = ?
        WHERE id = ?
        ''',
        [message, now.toIso8601String(), localId],
      );

      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = 'failed',
          last_error = ?,
          next_attempt_at = ?,
          updated_at = ?
        WHERE id = ?
        ''',
        [
          message,
          nextAttempt.toIso8601String(),
          now.toIso8601String(),
          'seal:$localId',
        ],
      );
    });
  }

  Future<void> marcarSelagemComoConflito({
    required String localId,
    required String message,
  }) async {
    await transaction(() async {
      final now = DateTime.now().toIso8601String();

      await customStatement(
        '''
        UPDATE selagens
        SET
          synced = 0,
          sync_status = 'conflict',
          sync_error = ?,
          sync_attempts = sync_attempts + 1,
          last_sync_attempt_at = ?
        WHERE id = ?
        ''',
        [message, now, localId],
      );

      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = 'conflict',
          last_error = ?,
          updated_at = ?
        WHERE id = ?
        ''',
        [message, now, 'seal:$localId'],
      );
    });
  }

  Future<void> restaurarFilaPresaEmSincronizacao() async {
    final now = DateTime.now();
    final threshold =
        now.subtract(const Duration(minutes: 5)).toIso8601String();

    await customStatement(
      '''
      UPDATE sync_queue
      SET
        status = 'pending',
        updated_at = ?
      WHERE status = 'syncing'
        AND updated_at < ?
      ''',
      [now.toIso8601String(), threshold],
    );

    await customStatement(
      '''
      UPDATE selagens
      SET sync_status = 'pending'
      WHERE sync_status = 'syncing'
      ''',
    );
  }

  Future<Map<String, int>> resumoSincronizacaoSelagens() async {
    final rows = await customSelect(
      '''
      SELECT sync_status, COUNT(*) AS total
      FROM selagens
      GROUP BY sync_status
      ''',
    ).get();

    final result = <String, int>{
      'pending': 0,
      'syncing': 0,
      'synced': 0,
      'failed': 0,
      'conflict': 0,
    };

    for (final row in rows) {
      final status = row.data['sync_status']?.toString() ?? 'pending';
      result[status] = row.data['total'] as int? ?? 0;
    }

    return result;
  }

  Future<void> liberarFilaParaTentativa({
    required String entityType,
    String? projectId,
  }) async {
    final now = DateTime.now().toIso8601String();

    if (projectId == null) {
      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = CASE
            WHEN status = 'conflict' THEN status
            ELSE 'pending'
          END,
          next_attempt_at = NULL,
          updated_at = ?
        WHERE entity_type = ?
          AND status IN ('failed', 'pending', 'syncing')
        ''',
        [now, entityType],
      );
    } else {
      await customStatement(
        '''
        UPDATE sync_queue
        SET
          status = CASE
            WHEN status = 'conflict' THEN status
            ELSE 'pending'
          END,
          next_attempt_at = NULL,
          updated_at = ?
        WHERE entity_type = ?
          AND project_id = ?
          AND status IN ('failed', 'pending', 'syncing')
        ''',
        [now, entityType, projectId],
      );
    }

    await customStatement(
      '''
      UPDATE selagens
      SET sync_status = 'pending'
      WHERE sync_status IN ('failed', 'syncing')
      ''',
    );
  }

  Future<List<Map<String, Object?>>> listarFalhasSincronizacaoSelagens({
    int limit = 30,
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        s.id,
        s.codigo_selo,
        s.sync_status,
        s.sync_error,
        s.sync_attempts,
        s.last_sync_attempt_at,
        s.projeto_id
      FROM selagens s
      WHERE s.sync_status IN ('failed', 'conflict')
      ORDER BY
        CASE s.sync_status
          WHEN 'conflict' THEN 0
          ELSE 1
        END,
        s.last_sync_attempt_at DESC
      LIMIT ?
      ''',
      variables: [Variable.withInt(limit)],
    ).get();

    return rows.map((row) => row.data).toList();
  }

  Future<List<Map<String, Object?>>> listarProjetosReurb() async {
    final rows = await customSelect(
      '''
      SELECT
        id,
        nome,
        municipio,
        estado,
        bairro,
        modalidade_reurb,
        area_ha,
        lotes_estimados,
        status,
        created_at
      FROM projetos
      ORDER BY created_at DESC
      ''',
    ).get();

    return rows.map((row) => row.data).toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'biome_reurb.sqlite'));
    return NativeDatabase(file);
  });
}

class CadastrosFisicos extends Table {
  TextColumn get id => text()();
  TextColumn get projetoId => text()();
  TextColumn get selagemId => text().nullable()();

  TextColumn get codigoSelo => text()();

  TextColumn get tipoImovel => text().nullable()();
  TextColumn get usoImovel => text().nullable()();

  TextColumn get materialParedes => text().nullable()();
  TextColumn get tipoCobertura => text().nullable()();
  TextColumn get tipoPiso => text().nullable()();

  IntColumn get numeroPavimentos => integer().nullable()();
  IntColumn get numeroComodos => integer().nullable()();
  IntColumn get numeroBanheiros => integer().nullable()();

  BoolColumn get possuiEnergia =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get possuiAgua => boolean().withDefault(const Constant(false))();
  BoolColumn get possuiEsgoto => boolean().withDefault(const Constant(false))();
  BoolColumn get possuiBanheiro =>
      boolean().withDefault(const Constant(false))();

  TextColumn get condicaoHabitabilidade => text().nullable()();

  BoolColumn get areaRisco => boolean().withDefault(const Constant(false))();
  BoolColumn get sujeitoInundacao =>
      boolean().withDefault(const Constant(false))();

  TextColumn get observacoes => text().nullable()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CadastrosSociais extends Table {
  TextColumn get id => text()();
  TextColumn get projetoId => text()();
  TextColumn get selagemId => text().nullable()();

  TextColumn get codigoSelo => text()();

  TextColumn get nomeResponsavel => text()();
  TextColumn get cpfResponsavel => text().nullable()();
  TextColumn get rgResponsavel => text().nullable()();
  TextColumn get orgaoEmissor => text().nullable()();
  TextColumn get estadoCivil => text().nullable()();
  TextColumn get profissao => text().nullable()();
  TextColumn get telefone => text().nullable()();

  IntColumn get quantidadeMoradores => integer().nullable()();
  RealColumn get rendaFamiliar => real().nullable()();

  BoolColumn get recebeProgramaSocial =>
      boolean().withDefault(const Constant(false))();
  TextColumn get programaSocial => text().nullable()();

  IntColumn get tempoOcupacaoAnos => integer().nullable()();
  TextColumn get formaOcupacao => text().nullable()();
  TextColumn get documentoPosse => text().nullable()();

  BoolColumn get possuiOutroImovel =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get possuiConflito =>
      boolean().withDefault(const Constant(false))();

  TextColumn get observacoes => text().nullable()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class DocumentosReurb extends Table {
  TextColumn get id => text()();
  TextColumn get projetoId => text()();
  TextColumn get selagemId => text().nullable()();
  TextColumn get cadastroSocialId => text().nullable()();

  TextColumn get codigoSelo => text()();

  TextColumn get tipoDocumento => text()();
  TextColumn get arquivoPath => text()();

  TextColumn get observacoes => text().nullable()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class LotesPreliminares extends Table {
  TextColumn get id => text()();
  TextColumn get projetoId => text()();

  TextColumn get codigoLote => text()();
  TextColumn get quadra => text().nullable()();

  RealColumn get areaM2 => real().nullable()();
  RealColumn get perimetroM => real().nullable()();

  TextColumn get geometriaGeojson => text().nullable()();

  TextColumn get origemArquivo => text().nullable()();
  TextColumn get tipoGeometria => text().nullable()();

  TextColumn get statusLote =>
      text().withDefault(const Constant('preliminar'))();
  BoolColumn get necessitaRevisao =>
      boolean().withDefault(const Constant(false))();

  TextColumn get observacoes => text().nullable()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class LotesVetorizadosCidadao extends Table {
  TextColumn get id => text()();

  TextColumn get projetoId => text().nullable()();
  TextColumn get selagemId => text().nullable()();
  TextColumn get cadastroSocialId => text().nullable()();

  TextColumn get codigoSelo => text().nullable()();
  TextColumn get codigoLote => text().nullable()();

  TextColumn get origem =>
      text().withDefault(const Constant('cidadao_assistido'))();

  TextColumn get status => text().withDefault(const Constant('rascunho'))();

  TextColumn get geometriaGeojson => text()();

  RealColumn get areaM2 => real().nullable()();
  RealColumn get perimetroM => real().nullable()();

  TextColumn get observacoes => text().nullable()();

  TextColumn get printPath => text().nullable()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
