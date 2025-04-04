class ApiResponse<T> {
  final String status;
  final int code;
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T? Function(dynamic) fromJsonT) {
    return ApiResponse(
      status: json['status'] ?? '',
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  factory ApiResponse.error({
    int code = 500,
    String message = 'An error occurred',
  }) {
    return ApiResponse(
      status: 'error',
      code: code,
      success: false,
      message: message,
      data: null,
    );
  }

  factory ApiResponse.success({
    int code = 200,
    String message = 'Success',
    required T? data,
  }) {
    return ApiResponse(
      status: 'success',
      code: code,
      success: true,
      message: message,
      data: data,
    );
  }
}
