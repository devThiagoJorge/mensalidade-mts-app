import 'package:dio/dio.dart';
import 'package:mensalidade_mts_app/features/auth/data/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    return UserModel.fromJson(response.data);
  }
}
