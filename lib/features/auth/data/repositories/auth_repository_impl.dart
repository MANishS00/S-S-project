import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;

  AuthRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  @override
  Future<Map<String, String>> login(String email, String password) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/jwt/create/');
    final response = await client.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'access': data['access'] as String,
        'refresh': data['refresh'] as String,
      };
    } else {
      throw Exception('Failed to login. Error: ${response.body}');
    }
  }

  @override
  Future<Map<String, String>> refreshToken(String refreshToken) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/jwt/refresh/');
    final response = await client.post(
      url,
      body: json.encode({'refresh': refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'access': data['access'] as String,
        'refresh': data['refresh'] ?? refreshToken,
      };
    } else {
      throw Exception('Failed to refresh token. Error: ${response.body}');
    }
  }

  @override
  Future<bool> verifyToken(String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/jwt/verify/');
    final response = await client.post(
      url,
      body: json.encode({'token': token}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  @override
  Future<void> resetPassword(String email) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/users/reset_password/');
    final response = await client.post(
      url,
      body: json.encode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password. Error: ${response.body}');
    }
  }

  @override
  Future<void> setPassword(String currentPassword, String newPassword, String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/users/set_password/');
    final response = await client.post(
      url,
      body: json.encode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set password. Error: ${response.body}');
    }
  }

  @override
  Future<void> register(
    String email,
    String password1,
    String password2,
    String firstName,
    String lastName,
    String uniqueId,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/users/');
    final response = await client.post(
      url,
      body: json.encode({
        'email': email,
        'password1': password1,
        'password2': password2,
        'first_name': firstName,
        'last_name': lastName,
        'unique_id': uniqueId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register. Error: ${response.body}');
    }
  }

  @override
  Future<UserModel> fetchUserDetails(String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/users/me/');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user details. Error: ${response.body}');
    }
  }
}
