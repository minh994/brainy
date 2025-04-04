import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/api_response.dart';
import '../../models/auth_models.dart';
import '../storage/storage_service.dart';
import '../../config/env_config.dart';

class BrainyApiClient {
  final String baseUrl;
  final StorageService storageService;
  final http.Client httpClient;
  final EnvConfig _envConfig = EnvConfig();

  BrainyApiClient({
    String? baseUrl,
    required this.storageService,
    http.Client? httpClient,
  })  : baseUrl = baseUrl ?? EnvConfig().apiBaseUrl,
        httpClient = httpClient ?? http.Client();

  /// Perform a GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint,
    T Function(dynamic) fromJson, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _performRequest(
        'GET',
        endpoint,
        requiresAuth: requiresAuth,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Perform a POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body,
    T Function(dynamic) fromJson, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _performRequest(
        'POST',
        endpoint,
        body: body,
        requiresAuth: requiresAuth,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Perform a PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint,
    dynamic body,
    T Function(dynamic) fromJson, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _performRequest(
        'PUT',
        endpoint,
        body: body,
        requiresAuth: requiresAuth,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Perform a DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint,
    T Function(dynamic) fromJson, {
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _performRequest(
        'DELETE',
        endpoint,
        requiresAuth: requiresAuth,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic) fromJson,
  ) {
    final jsonData = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.fromJson(jsonData, fromJson);
    } else {
      return ApiResponse(
        status: jsonData['status'] ?? 'error',
        code: jsonData['code'] ?? response.statusCode,
        success: jsonData['success'] ?? false,
        message: jsonData['message'] ?? 'Unknown error',
        data: null,
      );
    }
  }

  /// Perform HTTP request with appropriate headers
  Future<http.Response> _performRequest(
    String method,
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final request = http.Request(method, uri);
    request.headers.addAll(headers);

    if (body != null) {
      request.body = json.encode(body);
    }

    // Set timeout
    final timeout = _envConfig.apiTimeout;

    try {
      final streamedResponse = await httpClient
          .send(request)
          .timeout(Duration(milliseconds: timeout));
      return http.Response.fromStream(streamedResponse);
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Get auth token from storage
  Future<String?> _getAuthToken() async {
    final tokenKey = _envConfig.authTokenKey;
    final tokenJson = await storageService.get(tokenKey);
    if (tokenJson != null) {
      try {
        final token = AuthToken.fromJson(json.decode(tokenJson));
        return token.accessToken;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
