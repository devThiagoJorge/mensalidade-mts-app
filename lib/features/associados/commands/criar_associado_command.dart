class CriarAssociadoCommand {
  final String primeiroNome;
  final String sobreNome;
  final String email;
  final int diaVencimentoPagamento;
  final bool gerarDesdeComecoGestao;

  CriarAssociadoCommand({
    required this.primeiroNome,
    required this.sobreNome,
    required this.email,
    required this.diaVencimentoPagamento,
    required this.gerarDesdeComecoGestao,
  });
}
