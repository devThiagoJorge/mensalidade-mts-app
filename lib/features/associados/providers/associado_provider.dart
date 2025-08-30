import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/associados/associado_service.dart';
import 'package:mensalidade_mts_app/features/associados/models/associados.dart';

class AssociadoProvider extends ChangeNotifier {
  final AssociadoService associadoService;

  AssociadoProvider(this.associadoService);

  Associado? _associado;
  Associado? get associado => _associado;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<MappingResponse<Associado>> obterPorId(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await associadoService.obterPorId(id);

      if (result.success && result.data != null) {
        _associado = result.data;

        return result;
      } else {
        _error = result.message;
      }
      return result;
    } catch (e) {
      _error = e.toString();
      return MappingResponse<Associado>(success: false, message: _error!);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
