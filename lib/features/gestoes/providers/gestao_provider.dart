import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/gestoes/commands/atualizar_mensalidade_command.dart';
import 'package:mensalidade_mts_app/features/gestoes/gestao_service.dart';

class GestaoProvider extends ChangeNotifier {
  final GestaoService gestaoService;

  GestaoProvider(this.gestaoService);

  MappingResponse? _response;
  MappingResponse? get response => _response;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> atualizarValorMensalidade(
    AtualizarMensalidadeCommand command,
  ) async {
    _loading = true;
    _error = null;
    _response = null;
    notifyListeners();

    try {
      final result = await gestaoService.atualizarValorMensalidade(command);
      _response = result;

      if (!result.success) {
        _error = result.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
