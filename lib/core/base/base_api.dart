import 'dart:convert';
import 'package:http/http.dart' as http;

enum HttpMethod { get, post, put, delete }

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    required this.success,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(data: data, success: true);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(error: error, success: false);
  }
}

class BaseApi {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  BaseApi({
    required this.baseUrl,
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  Future<ApiResponse<T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    dynamic body,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      final requestHeaders = {
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

      http.Response response;

      switch (method) {
        case HttpMethod.get:
          response = await http.get(uri, headers: requestHeaders);
          break;
        case HttpMethod.post:
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpMethod.put:
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpMethod.delete:
          response = await http.delete(
            uri,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body);
        return ApiResponse.success(fromJson(jsonData));
      } else {
        return ApiResponse.error(
            'Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
}
