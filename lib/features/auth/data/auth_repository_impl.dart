import 'package:mensalidade_mts_app/features/auth/data/auth_remote_datasource.dart';
import 'package:mensalidade_mts_app/features/auth/domain/auth_repository.dart';
import 'package:mensalidade_mts_app/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }
}
