class Pagamento {
  String statusNome;
  final double valor;
  final DateTime? dataPagamento;
  final int diaVencimento;
  final int referenteMes;
  final int referenteAno;

  Pagamento({
    required this.statusNome,
    required this.valor,
    this.dataPagamento,
    required this.diaVencimento,
    required this.referenteMes,
    required this.referenteAno,
  });

  factory Pagamento.fromJson(Map<String, dynamic> json) {
    return Pagamento(
      statusNome: json['statusNome'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      dataPagamento: json['dataPagamento'] != null
          ? DateTime.tryParse(json['dataPagamento'])
          : null,
      diaVencimento: json['diaVencimento'] ?? 0,
      referenteMes: json['referenteMes'] ?? 0,
      referenteAno: json['referenteAno'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusNome': statusNome,
      'valor': valor,
      'dataPagamento': dataPagamento?.toIso8601String(),
      'referenteMes': referenteMes,
      'referenteAno': referenteAno,
      'diaVencimento': diaVencimento,
    };
  }
}
