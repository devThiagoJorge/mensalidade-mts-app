import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/pagamentos/pagamento_service.dart';
import 'package:mensalidade_mts_app/features/tesoureiros/models/pagamentos_associados.dart';

class PagamentoProvider extends ChangeNotifier {
  final PagamentoService pagamentoService;

  PagamentoProvider(this.pagamentoService);

  MensalidadesAssociados? _mensalidades;
  MensalidadesAssociados? get mensalidades => _mensalidades;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<MappingResponse<MensalidadesAssociados>> obterMensalidadeAssociados(
    String params,
  ) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await pagamentoService.obterMensalidadeAssociados(params);

      if (result.success && result.data != null) {
        _mensalidades = result.data;

        return result;
      } else {
        _error = result.message;
      }
      return result;
    } catch (e) {
      _error = e.toString();
      return MappingResponse<MensalidadesAssociados>(
        success: false,
        message: _error!,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
