import 'package:mensalidade_mts_app/core/network/api_service.dart';

class TesoureiroService {
  final ApiService api;
  final String prefixo = '/Associados';
  TesoureiroService(this.api);

  // Future<MappingResponse<Associado>> obterPorId(int id) {
  //   return api.get<Associado>(
  //     '$prefixo/$id',
  //     (json) => Associado.fromJson(json),
  //   );
  // }
}
