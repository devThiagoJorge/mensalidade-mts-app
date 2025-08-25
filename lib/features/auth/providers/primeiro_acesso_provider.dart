import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/auth/auth_service.dart';

class PrimeiroAcessoProvider extends ChangeNotifier {
  final AuthService authService;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  MappingResponse? _response;
  MappingResponse? get response => _response;

  PrimeiroAcessoProvider(this.authService);

  Future<void> solicitarPrimeiroAcesso(String email) async {
    _setLoading(true);
    try {
      final result = await authService.primeiroAcesso(email);
      _response = result;

      if (!result.success) {
        _error = result.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> validarCodigo(String codigo) async {
    _setLoading(true);
    try {
      final result = await authService.validarCodigo(codigo);
      _response = result;

      if (!result.success) {
        _error = result.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> definirSenha(String email, String senha, String codigo) async {
    _setLoading(true);
    try {
      final result = await authService.definirSenha(email, senha, codigo);
      _response = result;

      if (!result.success) {
        _error = result.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void reset() {
    _error = null;
    _response = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
