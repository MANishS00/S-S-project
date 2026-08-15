import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  bool _isLoading = false;
  File? _selectedImage;

  bool _isBankDetailsLoading = false;
  bool _isEditingBankDetails = false;

  final phoneController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  final countryController = TextEditingController();

  final bankNameController = TextEditingController();
  final bankEmailController = TextEditingController();
  final bankPhoneController = TextEditingController();
  final bankContactTypeController = TextEditingController();
  final bankAccountNumberController = TextEditingController();
  final bankIfscController = TextEditingController();

  ProfileViewModel({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepositoryImpl();

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  File? get selectedImage => _selectedImage;

  bool get isBankDetailsLoading => _isBankDetailsLoading;
  bool get isEditingBankDetails => _isEditingBankDetails;

  Future<void> fetchProfile() async {
    final token = await TokenHelper.getValidToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _profileRepository.fetchProfile(token);
      if (_profile != null) {
        phoneController.text = _profile!.phone ?? '';
        address1Controller.text = _profile!.address1 ?? '';
        address2Controller.text = _profile!.address2 ?? '';
        cityController.text = _profile!.city ?? '';
        stateController.text = _profile!.state ?? '';
        zipcodeController.text = _profile!.zipcode ?? '';
        countryController.text = _profile!.country ?? '';
      }
    } catch (e) {
      // Allow error handling or bubble up
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> submitProfile() async {
    final token = await TokenHelper.getValidToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _profileRepository.updateProfile(
        token,
        image: _selectedImage,
        phone: phoneController.text,
        address1: address1Controller.text,
        address2: address2Controller.text,
        city: cityController.text,
        state: stateController.text,
        zipcode: zipcodeController.text,
        country: countryController.text,
      );
      _selectedImage = null; // Clear image after successful submit
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
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

  @override
  void dispose() {
    phoneController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipcodeController.dispose();
    countryController.dispose();
    bankNameController.dispose();
    bankEmailController.dispose();
    bankPhoneController.dispose();
    bankContactTypeController.dispose();
    bankAccountNumberController.dispose();
    bankIfscController.dispose();
    super.dispose();
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

  void setEditingBankDetails(bool editing) {
    _isEditingBankDetails = editing;
    if (!editing) {
      populateBankControllers();
    }
    notifyListeners();
  }

  void populateBankControllers() {
    if (_bankDetails != null) {
      bankNameController.text = _bankDetails!.accountHolderName;
      bankEmailController.text = _bankDetails!.email;
      bankPhoneController.text = _bankDetails!.phoneNumber;
      bankContactTypeController.text = _bankDetails!.contactType;
      bankAccountNumberController.text = _bankDetails!.accountNumber;
      bankIfscController.text = _bankDetails!.ifscCode;
    }
  }

  Future<void> fetchBankDetails() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;
    _isBankDetailsLoading = true;
    notifyListeners();
    try {
      _bankDetails = await _profileRepository.fetchBankDetails(token);
      populateBankControllers();
    } finally {
      _isBankDetailsLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitBankDetails(BankDetailsModel details) async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;
    _isBankDetailsLoading = true;
    notifyListeners();
    try {
      _bankDetails = await _profileRepository.submitBankDetails(details, token);
      populateBankControllers();
      notifyListeners();
    } finally {
      _isBankDetailsLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBankDetails() async {
    final details = BankDetailsModel(
      id: _bankDetails?.id ?? 0,
      accountHolderName: bankNameController.text.trim(),
      email: bankEmailController.text.trim(),
      phoneNumber: bankPhoneController.text.trim(),
      contactType: bankContactTypeController.text.trim(),
      accountNumber: bankAccountNumberController.text.trim(),
      ifscCode: bankIfscController.text.trim(),
    );
    await submitBankDetails(details);
    _isEditingBankDetails = false;
    notifyListeners();
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
