import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final http.Client client;

  ProfileRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<ProfileModel> fetchProfile(int userId, String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/profile/$userId/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch profile. Error: ${response.body}');
    }
  }

  @override
  Future<ProfileModel> updateProfile(
    int userId,
    String token, {
    File? image,
    String? phone,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? zipcode,
    String? country,
  }) async {
    final url = Uri.parse('${Config.baseUrl}/api/profile/$userId/');
    final request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    if (phone != null) request.fields['phone'] = phone;
    if (address1 != null) request.fields['address1'] = address1;
    if (address2 != null) request.fields['address2'] = address2;
    if (city != null) request.fields['city'] = city;
    if (state != null) request.fields['state'] = state;
    if (zipcode != null) request.fields['zipcode'] = zipcode;
    if (country != null) request.fields['country'] = country;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProfileModel.fromJson(data);
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }
}
