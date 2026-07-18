import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/referral_model.dart';
import '../../data/models/bank_details_model.dart';
import '../../data/models/referral_tree_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../../../core/utils/token_helper.dart';

class ProfileViewModel with ChangeNotifier {
  final ProfileRepository _profileRepository;

  ProfileModel? _profile;

  ProfileViewModel({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepositoryImpl();

  ProfileModel? get profile => _profile;

  Future<void> fetchProfile() async {
    final token = await TokenHelper.getValidToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    try {
      _profile = await _profileRepository.fetchProfile(token);
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
    final token = await TokenHelper.getValidToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    try {
      _profile = await _profileRepository.updateProfile(
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

  List<ReferralModel> _referrals = [];
  List<ReferralModel> get referrals => _referrals;

  BankDetailsModel? _bankDetails;
  BankDetailsModel? get bankDetails => _bankDetails;

  Future<void> fetchReferrals() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;
    try {
      _referrals = await _profileRepository.fetchReferrals(token);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> fetchBankDetails() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;
    try {
      _bankDetails = await _profileRepository.fetchBankDetails(token);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> submitBankDetails(BankDetailsModel details) async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;
    try {
      _bankDetails = await _profileRepository.submitBankDetails(details, token);
      notifyListeners();
    } catch (_) {}
  }

  List<ReferralTreeModel> _referralTree = [];
  List<ReferralTreeModel> get referralTree => _referralTree;

  Future<void> fetchReferralTree() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;
    try {
      _referralTree = await _profileRepository.fetchReferralTree(token);
      notifyListeners();
    } catch (_) {}
  }
}
