import 'package:mensalidade_mts_app/features/auth/domain/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
}
