import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/api_response.dart';
import '../../models/auth_models.dart';
import '../storage/storage_service.dart';

class BrainyApiClient {
  final String baseUrl;
  final StorageService storageService;
  final http.Client httpClient;

  BrainyApiClient({
    required this.baseUrl,
    required this.storageService,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

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

    switch (method) {
      case 'GET':
        return httpClient.get(uri, headers: headers);
      case 'POST':
        return httpClient.post(uri, headers: headers, body: json.encode(body));
      case 'PUT':
        return httpClient.put(uri, headers: headers, body: json.encode(body));
      case 'DELETE':
        return httpClient.delete(uri, headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  /// Get auth token from storage
  Future<String?> _getAuthToken() async {
    final tokenJson = await storageService.get('auth_token');
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
