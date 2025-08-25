import 'package:dio/dio.dart';
import 'package:mensalidade_mts_app/core/response/mapping_response.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<MappingResponse<T>> post<T>(
    String url,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await dio.post(url, data: body);

      return MappingResponse<T>(
        success: true,
        message: response.data['message'],
        data: fromJson(response.data['data']),
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      return MappingResponse<T>(
        success: false,
        message:
            data?['message'] ?? e.response?.statusMessage ?? 'Erro inesperado',
      );
    } catch (e) {
      return MappingResponse<T>(success: false, message: e.toString());
    }
  }
}
