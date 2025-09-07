class AtualizarPagamentoCommand {
  final List<int> idsPagamentos;
  final int statusPagamentoId;
  final DateTime dataPagamento;

  AtualizarPagamentoCommand({
    required this.idsPagamentos,
    required this.statusPagamentoId,
    required this.dataPagamento,
  });
}
