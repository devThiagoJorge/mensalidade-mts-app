import 'package:mensalidade_mts_app/features/pagamentos/models/pagamento.dart';

class Associado {
  final String nomeCompleto;
  final String email;
  final String role;
  final String gestao;
  final bool ativo;
  final DateTime dataRegistro;
  final List<Pagamento> pagamentosAtrasados;
  final List<Pagamento> pagamentosPendentes;
  final List<Pagamento> pagamentosPagos;

  Associado({
    required this.nomeCompleto,
    required this.email,
    required this.role,
    required this.gestao,
    required this.ativo,
    required this.dataRegistro,
    required this.pagamentosAtrasados,
    required this.pagamentosPendentes,
    required this.pagamentosPagos,
  });

  factory Associado.fromJson(Map<String, dynamic> json) {
    return Associado(
      nomeCompleto: json['nomeCompleto'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      gestao: json['gestao'] as String,
      ativo: json['ativo'] as bool,
      dataRegistro: DateTime.parse(json['dataRegistro']),
      pagamentosAtrasados:
          (json['pagamentosAtrasados'] as List<dynamic>?)
              ?.map((e) => Pagamento.fromJson(e))
              .toList() ??
          [],
      pagamentosPendentes:
          (json['pagamentosPendentes'] as List<dynamic>?)
              ?.map((e) => Pagamento.fromJson(e))
              .toList() ??
          [],
      pagamentosPagos:
          (json['pagamentosPagos'] as List<dynamic>?)
              ?.map((e) => Pagamento.fromJson(e))
              .toList() ??
          [],
    );
  }
}
