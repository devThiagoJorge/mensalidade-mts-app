import 'package:mensalidade_mts_app/core/network/api_service.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';
import 'package:mensalidade_mts_app/features/associados/models/associados.dart';

class AssociadoService {
  final ApiService api;
  final String prefixo = '/Associados';
  AssociadoService(this.api);

  Future<MappingResponse<Associado>> obterPorId(int id) {
    return api.get<Associado>(
      '$prefixo/$id',
      (json) => Associado.fromJson(json),
    );
  }
}
