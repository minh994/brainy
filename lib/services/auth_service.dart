import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000/api'; // Thay đổi URL theo backend của bạn

  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to login');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<User> signup(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to signup');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/logout'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 