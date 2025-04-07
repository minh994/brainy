class ApiResponse<T> {
  final String status;
  final int code;
  final bool success;
  final String message;
  final T? data;
  final int? totalCount;

  ApiResponse({
    required this.status,
    required this.code,
    required this.success,
    required this.message,
    this.data,
    this.totalCount,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    final data = json.containsKey('data') ? json['data'] : json;

    // Extract totalCount from top level fields
    final totalCount = json['data']['total'];

    return ApiResponse(
      status: json['status'] ?? 'error',
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT(data),
      totalCount: totalCount,
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
      totalCount: null,
    );
  }

  factory ApiResponse.success({
    int code = 200,
    String message = 'Success',
    required T? data,
    int? totalCount,
  }) {
    return ApiResponse(
      status: 'success',
      code: code,
      success: true,
      message: message,
      data: data,
      totalCount: totalCount,
    );
  }
}
