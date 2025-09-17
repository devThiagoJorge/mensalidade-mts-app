import 'package:mensalidade_mts_app/core/network/api_service.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/gestoes/commands/atualizar_mensalidade_command.dart';

class GestaoService {
  final ApiService api;
  final String prefixo = '/Gestoes';
  GestaoService(this.api);

  Future<MappingResponse<void>> atualizarValorMensalidade(
    AtualizarMensalidadeCommand command,
  ) {
    return api.put<void>('$prefixo/mensalidade/valor', {
      'dataReferencia': command.dataReferencia.toIso8601String(),
      'novoValor': command.novoValor,
    }, (_) {});
  }
}
