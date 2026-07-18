import 'dart:io';
import '../../data/models/profile_model.dart';
import '../../data/models/referral_model.dart';
import '../../data/models/bank_details_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> fetchProfile(String token);
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
  });
  Future<List<ReferralModel>> fetchReferrals(String token);
  Future<BankDetailsModel?> fetchBankDetails(String token);
  Future<BankDetailsModel> submitBankDetails(BankDetailsModel details, String token);
}
