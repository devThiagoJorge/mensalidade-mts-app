class MensalidadesAssociados {
  final String gestao;
  final List<PagamentoAssociadosDto> pagamentosAtrasados;
  final List<PagamentoAssociadosDto> pagamentosPendentes;
  final List<PagamentoAssociadosDto> pagamentosPagos;
  final double valorTotalPagamentosAtrasados;
  final double valorTotalPagamentosPendentes;
  final double valorTotalPagamentosPagos;

  MensalidadesAssociados({
    required this.gestao,
    required this.pagamentosAtrasados,
    required this.pagamentosPendentes,
    required this.pagamentosPagos,
    required this.valorTotalPagamentosAtrasados,
    required this.valorTotalPagamentosPendentes,
    required this.valorTotalPagamentosPagos,
  });

  factory MensalidadesAssociados.fromJson(Map<String, dynamic> json) {
    return MensalidadesAssociados(
      gestao: json['gestao'] ?? '',
      valorTotalPagamentosAtrasados:
          (json['valorTotalPagamentosAtrasados'] ?? 0).toDouble(),
      valorTotalPagamentosPendentes:
          (json['valorTotalPagamentosPendentes'] ?? 0).toDouble(),
      valorTotalPagamentosPagos: (json['valorTotalPagamentosPagos'] ?? 0)
          .toDouble(),
      pagamentosAtrasados:
          (json['pagamentosAtrasados'] as List<dynamic>?)
              ?.map((e) => PagamentoAssociadosDto.fromJson(e))
              .toList() ??
          [],
      pagamentosPendentes:
          (json['pagamentosPendentes'] as List<dynamic>?)
              ?.map((e) => PagamentoAssociadosDto.fromJson(e))
              .toList() ??
          [],
      pagamentosPagos:
          (json['pagamentosPagos'] as List<dynamic>?)
              ?.map((e) => PagamentoAssociadosDto.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PagamentoAssociadosDto {
  final int idPagamento;
  String statusNome;
  final double valor;
  final DateTime? dataPagamento;
  final int diaVencimento;
  final int referenteMes;
  final int referenteAno;
  final String nomeCompleto;

  PagamentoAssociadosDto({
    required this.idPagamento,
    required this.statusNome,
    required this.valor,
    this.dataPagamento,
    required this.diaVencimento,
    required this.referenteMes,
    required this.referenteAno,
    required this.nomeCompleto,
  });

  factory PagamentoAssociadosDto.fromJson(Map<String, dynamic> json) {
    return PagamentoAssociadosDto(
      idPagamento: json['idPagamento'] ?? 0,
      statusNome: json['statusNome'] ?? '',
      nomeCompleto: json['nomeCompleto'] ?? '',
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
      'idPagamento': idPagamento,
      'statusNome': statusNome,
      'valor': valor,
      'dataPagamento': dataPagamento?.toIso8601String(),
      'referenteMes': referenteMes,
      'referenteAno': referenteAno,
      'diaVencimento': diaVencimento,
      'nomeCompleto': nomeCompleto,
    };
  }
}
