import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/repositories/profile_repository_impl.dart';

class ProfileViewModel with ChangeNotifier {
  final ProfileRepository _profileRepository;

  ProfileModel? _profile;

  ProfileViewModel({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepositoryImpl();

  ProfileModel? get profile => _profile;

  Future<void> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    try {
      _profile = await _profileRepository.fetchProfile(userId, token);
      notifyListeners();
    } catch (e) {
      // // rethrow;
    }
  }

  Future<void> updateProfile({
    File? image,
    String? phone,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? zipcode,
    String? country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    try {
      _profile = await _profileRepository.updateProfile(
        userId,
        token,
        image: image,
        phone: phone,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        zipcode: zipcode,
        country: country,
      );
      notifyListeners();
    } catch (e) {
      // rethrow;
    }
  }
}
