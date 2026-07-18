import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../models/referral_model.dart';
import '../models/bank_details_model.dart';
import '../models/referral_tree_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final http.Client client;

  ProfileRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<ProfileModel> fetchProfile(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/profile/me/');
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
      throw Exception('Failed to fetch profile at $url. Status: ${response.statusCode}, Error: ${response.body}');
    }
  }

  @override
  Future<ProfileModel> updateProfile(
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
    final url = Uri.parse('${Config.baseUrl}/api/profile/me/');
    final request = http.MultipartRequest('PATCH', url);
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

  @override
  Future<List<ReferralModel>> fetchReferrals(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/user/referrals/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ReferralModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch referrals: ${response.body}');
    }
  }

  @override
  Future<BankDetailsModel?> fetchBankDetails(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/users/get-bank-details/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BankDetailsModel.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch bank details: ${response.body}');
    }
  }

  @override
  Future<BankDetailsModel> submitBankDetails(BankDetailsModel details, String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/users/bank-details/');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'account_holder_name': details.accountHolderName,
        'email': details.email,
        'phone_number': details.phoneNumber,
        'contact_type': details.contactType,
        'account_number': details.accountNumber,
        'ifsc_code': details.ifscCode,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return BankDetailsModel.fromJson(data);
    } else {
      throw Exception('Failed to submit bank details: ${response.body}');
    }
  }

  @override
  Future<List<ReferralTreeModel>> fetchReferralTree(String token) async {
    final url = Uri.parse('${Config.baseUrl}/mlmtree/api/tree/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ReferralTreeModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch referral tree: ${response.body}');
    }
  }
}
