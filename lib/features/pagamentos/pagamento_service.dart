import 'package:mensalidade_mts_app/core/network/api_service.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/pagamentos/commands/atualizar_pagamento_command.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/models/pagamentos_associados.dart';

class PagamentoService {
  final ApiService api;
  final String prefixo = '/Pagamentos';
  PagamentoService(this.api);

  Future<MappingResponse<MensalidadesAssociados>> obterMensalidadeAssociados(
    String params,
  ) {
    return api.get<MensalidadesAssociados>(
      '$prefixo/associados/mensalidades?$params',
      (json) => MensalidadesAssociados.fromJson(json),
    );
  }

  Future<MappingResponse<void>> atualizarPagamentos(
    AtualizarPagamentoCommand command,
  ) {
    return api.put<void>('$prefixo/associados', {
      'idsPagamentos': command.idsPagamentos,
      'statusPagamentoId': command.statusPagamentoId,
      'dataPagamento': command.dataPagamento.toIso8601String(),
    }, (_) {});
  }
}
