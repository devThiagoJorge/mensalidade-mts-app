import 'package:mensalidade_mts_app/core/network/api_service.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/auth/models/user.dart';

class AuthService {
  final ApiService api;
  final String prefixo = '/Authenticator/';
  AuthService(this.api);

  Future<MappingResponse<User>> login(String email, String senha) {
    return api.post<User>('$prefixo/login', {
      'email': email,
      'senha': senha,
    }, (json) => User.fromJson(json));
  }

  Future<MappingResponse<void>> primeiroAcesso(String email) {
    return api.post<void>('$prefixo/primeiro-acesso', {'email': email}, (_) {});
  }

  Future<MappingResponse<void>> validarCodigo(String codigo) {
    return api.post<void>('$prefixo/validar-codigo', {
      'codigo': codigo,
    }, (_) {});
  }

  Future<MappingResponse<void>> definirSenha(
    String email,
    String novaSenha,
    String codigoAcesso,
  ) {
    return api.post<void>('$prefixo/definir-senha-primeiro-acesso', {
      'email': email,
      'novaSenha': novaSenha,
      'codigoAcesso': codigoAcesso,
    }, (_) {});
  }
}
