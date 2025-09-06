import 'package:mensalidade_mts_app/core/network/api_service.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/associados/commands/criar_associado_command.dart';
import 'package:mensalidade_mts_app/features/associados/models/associados.dart';

class AssociadoService {
  final ApiService api;
  final String prefixo = '/Associados';
  AssociadoService(this.api);

  Future<MappingResponse<Associado>> obterPorId(int id) {
    return api.get<Associado>(
      '$prefixo/$id',
      (json) => Associado.fromJson(json),
    );
  }

  Future<MappingResponse<void>> cadastrarAssociado(
    CriarAssociadoCommand command,
  ) {
    return api.post<void>(prefixo, {
      'primeiroNome': command.primeiroNome,
      'sobrenome': command.sobreNome,
      'email': command.email,
      'diaPagamentoVencimento': command.diaVencimentoPagamento,
      'gerarDesdeComecoGestao': command.gerarDesdeComecoGestao,
    }, (_) {});
  }
}
