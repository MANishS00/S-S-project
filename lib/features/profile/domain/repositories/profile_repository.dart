import 'dart:io';
import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> fetchProfile(int userId, String token);
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
  });
}
