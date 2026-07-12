import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReurbReceiptPdfService {
  Future<File> generateCompleteReceiptPdf({
    required String projetoNome,
    required String municipio,
    required String estado,
    required String bairro,
    required String codigoSelo,
    String? codigoLote,
    String? situacaoSelagem,
    String? latitude,
    String? longitude,
    String? precisaoGps,
    required String nomeResponsavel,
    String? cpfResponsavel,
    String? rgResponsavel,
    String? telefone,
    String? estadoCivil,
    String? profissao,
    String? formaOcupacao,
    String? documentoImovel,
    String? tempoOcupacao,
    String? tipoImovel,
    String? usoImovel,
    String? materialParedes,
    String? tipoCobertura,
    String? tipoPiso,
    String? numeroComodos,
    String? numeroBanheiros,
    String? possuiEnergia,
    String? possuiAgua,
    String? possuiEsgoto,
    String? possuiBanheiro,
    String? condicaoHabitabilidade,
    String? areaRisco,
    String? sujeitoInundacao,
    required List<String> documentos,
    required DateTime dataEmissao,
    required String consultaUrl,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (context) {
          return [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'BIOME REURB',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green900,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Comprovante de Atendimento REURB',
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Selagem, cadastro social, cadastro físico e documentos declarados',
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  width: 88,
                  height: 88,
                  padding: const pw.EdgeInsets.all(4),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey500),
                  ),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: consultaUrl,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                border: pw.Border.all(color: PdfColors.green700),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Código da Selagem',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.green900,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    codigoSelo,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green900,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),
            _sectionTitle('1. Projeto / Núcleo'),
            _table([
              ['Projeto/Núcleo', _empty(projetoNome)],
              ['Município/UF', '${_empty(municipio)}/${_empty(estado)}'],
              ['Bairro/Núcleo', _empty(bairro)],
              ['Data de emissão', _formatDateTime(dataEmissao)],
            ]),
            pw.SizedBox(height: 12),
            _sectionTitle('2. Imóvel / Lote / Selagem'),
            _table([
              ['Código da selagem', _empty(codigoSelo)],
              ['Código do lote', _empty(codigoLote)],
              ['Situação da selagem', _label(situacaoSelagem)],
              ['Latitude', _empty(latitude)],
              ['Longitude', _empty(longitude)],
              ['Precisão GPS', _empty(precisaoGps)],
            ]),
            pw.SizedBox(height: 12),
            _sectionTitle('3. Responsável Familiar'),
            _table([
              ['Nome', _empty(nomeResponsavel)],
              ['CPF', _maskCpf(cpfResponsavel)],
              ['RG', _empty(rgResponsavel)],
              ['Telefone/WhatsApp', _empty(telefone)],
              ['Estado civil', _label(estadoCivil)],
              ['Profissão/Ocupação', _empty(profissao)],
            ]),
            pw.SizedBox(height: 12),
            _sectionTitle('4. Situação de Ocupação / Documento do Imóvel'),
            _table([
              ['Forma de ocupação', _label(formaOcupacao)],
              ['Documento do imóvel', _label(documentoImovel)],
              ['Tempo de ocupação', _empty(tempoOcupacao)],
            ]),
            pw.SizedBox(height: 12),
            _sectionTitle('5. Cadastro Físico do Imóvel'),
            _table([
              ['Tipo do imóvel', _label(tipoImovel)],
              ['Uso do imóvel', _label(usoImovel)],
              ['Material das paredes', _label(materialParedes)],
              ['Cobertura', _label(tipoCobertura)],
              ['Piso', _label(tipoPiso)],
              ['Cômodos', _empty(numeroComodos)],
              ['Banheiros', _empty(numeroBanheiros)],
              ['Energia elétrica', _empty(possuiEnergia)],
              ['Água', _empty(possuiAgua)],
              ['Esgoto', _empty(possuiEsgoto)],
              ['Banheiro', _empty(possuiBanheiro)],
              ['Habitabilidade', _label(condicaoHabitabilidade)],
              ['Área de risco', _empty(areaRisco)],
              ['Sujeito a inundação', _empty(sujeitoInundacao)],
            ]),
            pw.SizedBox(height: 12),
            _sectionTitle('6. Documentos Anexados'),
            documentos.isEmpty
                ? pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.Text(
                      'Nenhum documento anexado foi localizado no momento da emissão.',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  )
                : pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: documentos.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final name = entry.value;

                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 4),
                        child: pw.Text(
                          '$index. $name',
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      );
                    }).toList(),
                  ),
            pw.SizedBox(height: 16),
            _sectionTitle('7. Orientação para Consulta'),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                border: pw.Border.all(color: PdfColors.blueGrey200),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'Para acompanhar a situação do seu cadastro REURB, acesse o portal informado pela equipe técnica ou aponte a câmera do celular para o QR Code. '
                'Utilize seu CPF juntamente com o Código da Selagem constante neste comprovante.',
                style: const pw.TextStyle(fontSize: 10, lineSpacing: 4),
              ),
            ),
            pw.SizedBox(height: 14),
            _sectionTitle('8. Observação Importante'),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.amber50,
                border: pw.Border.all(color: PdfColors.amber700),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'Este comprovante não constitui título de propriedade, certidão de posse, promessa de regularização ou direito real sobre o imóvel. '
                'Sua finalidade é comprovar o atendimento técnico-cadastral realizado no âmbito do procedimento de Regularização Fundiária Urbana - REURB.',
                style: const pw.TextStyle(fontSize: 9, lineSpacing: 4),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Documento gerado automaticamente pelo aplicativo BIOME REURB.',
              style: const pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey700,
              ),
            ),
          ];
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory(p.join(dir.path, 'comprovantes_reurb'));

    if (!await receiptsDir.exists()) {
      await receiptsDir.create(recursive: true);
    }

    final safeSeal = _safeFilename(codigoSelo);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final file = File(
      p.join(
        receiptsDir.path,
        'comprovante_reurb_${safeSeal}_$timestamp.pdf',
      ),
    );

    await file.writeAsBytes(await pdf.save(), flush: true);

    return file;
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.green900,
        ),
      ),
    );
  }

  pw.Widget _table(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.15),
        1: pw.FlexColumnWidth(2),
      },
      children: rows.map((row) {
        return pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(7),
              color: PdfColors.grey100,
              child: pw.Text(
                row[0],
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(7),
              child: pw.Text(
                row[1],
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _empty(Object? value) {
    if (value == null) return '-';

    final text = value.toString().trim();

    return text.isEmpty ? '-' : text;
  }

  String _label(Object? value) {
    final text = _empty(value);

    if (text == '-') return '-';

    return text
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) {
      final lower = part.toLowerCase();
      return lower[0].toUpperCase() + lower.substring(1);
    }).join(' ');
  }

  String _formatDateTime(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');

    return '${two(value.day)}/${two(value.month)}/${value.year} '
        '${two(value.hour)}:${two(value.minute)}';
  }

  String _maskCpf(String? cpf) {
    if (cpf == null || cpf.trim().isEmpty) {
      return '-';
    }

    final digits = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length != 11) {
      return cpf;
    }

    return '***.${digits.substring(3, 6)}.${digits.substring(6, 9)}-**';
  }

  String _safeFilename(String value) {
    final normalized = value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');

    return normalized.isEmpty ? 'sem_codigo' : normalized;
  }
}
