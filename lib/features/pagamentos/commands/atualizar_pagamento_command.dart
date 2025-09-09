class AtualizarPagamentoCommand {
  final List<int> idsPagamentos;
  final int statusPagamentoId;
  DateTime? dataPagamento;

  AtualizarPagamentoCommand({
    required this.idsPagamentos,
    required this.statusPagamentoId,
    required this.dataPagamento,
  });

  void atualizarDataPagamento(DateTime data) {
    dataPagamento = data;
  }
}
