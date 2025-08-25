import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/auth/auth_service.dart';
import 'package:mensalidade_mts_app/features/auth/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  User? _user;
  User? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  AuthProvider(this.authService);

  Future<MappingResponse<User>> login(String email, String senha) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await authService.login(email, senha);

      if (result.success) {
        _user = result.data;
      } else {
        _error = result.message;
      }

      return result;
    } catch (e) {
      final msg = e.toString();
      _error = msg;

      return MappingResponse<User>(success: false, message: msg);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void reset() {
    _error = null;
    _user = null;
    _loading = false;
    notifyListeners();
  }
}
