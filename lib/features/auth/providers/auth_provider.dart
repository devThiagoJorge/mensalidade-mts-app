import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/auth/auth_service.dart';
import 'package:mensalidade_mts_app/features/auth/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final AuthService authService;
  AuthProvider(this.authService);

  User? _user;
  String? _token;
  String? _error;
  bool _loading = false;

  User? get user => _user;
  String? get token => _token;
  String? get error => _error;
  bool get loading => _loading;

  Future<void> _loadFromStorage() async {
    _token = await _storage.read(key: 'token');
    final role = await _storage.read(key: 'role');

    if (_token != null && role != null) {
      _user = User(
        token: user!.token,
        nome: user!.nome,
        role: role,
        id: user!.id,
      );
    }
    notifyListeners();
  }

  Future<MappingResponse<User>> login(String email, String senha) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await authService.login(email, senha);

      if (result.success && result.data != null) {
        _user = result.data;
        _token = result.data!.token;

        // Salva no storage
        await _storage.write(key: 'token', value: _token);
        await _storage.write(key: 'role', value: _user!.role);
        return result;
      } else {
        _error = result.message;
      }
      return result;
    } catch (e) {
      _error = e.toString();
      return MappingResponse<User>(success: false, message: _error!);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}
