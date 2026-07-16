import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;

  AuthRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<String> login(String email, String password) async {
    final url = Uri.parse('${Config.baseUrl}/api/auth/jwt/create/');
    final response = await client.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access'] as String;
    } else {
      throw Exception('Failed to login. Error: ${response.body}');
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
    final url = Uri.parse('${Config.baseUrl}/api/auth/users/');
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
    final url = Uri.parse('${Config.baseUrl}/api/auth/users/me/');
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
