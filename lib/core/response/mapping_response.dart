class MappingResponse<T> {
  final bool success;
  final String message;
  final T? data;

  MappingResponse({required this.success, this.message = '', this.data});

  factory MappingResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(Object? json) fromJsonT,
  ) {
    return MappingResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
