import 'package:flutter/material.dart';
import 'package:mensalidade_mts_app/features/auth/domain/auth_repository.dart';
import 'package:mensalidade_mts_app/features/auth/domain/user.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository repository;

  LoginProvider(this.repository);

  User? user;
  bool isLoading = false;
  String? error;

  Future<void> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await repository.login(email, password);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
