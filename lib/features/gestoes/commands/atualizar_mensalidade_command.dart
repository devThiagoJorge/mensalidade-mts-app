class AtualizarMensalidadeCommand {
  DateTime dataReferencia;
  final double novoValor;

  AtualizarMensalidadeCommand({
    required this.dataReferencia,
    required this.novoValor,
  });

  void atualizarDataReferencia(DateTime data) {
    dataReferencia = data;
  }
}
