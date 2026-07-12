class LoteMapaResult {
  final String lotePreliminarId;
  final String codigoLotePreliminar;
  final String statusVinculoGeografico;
  final bool necessitaValidacaoRtk;
  final String? observacaoGeoespacial;

  const LoteMapaResult({
    required this.lotePreliminarId,
    required this.codigoLotePreliminar,
    required this.statusVinculoGeografico,
    required this.necessitaValidacaoRtk,
    this.observacaoGeoespacial,
  });
}
