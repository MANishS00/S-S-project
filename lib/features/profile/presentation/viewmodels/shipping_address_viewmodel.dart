import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/shipping_address_model.dart';
import '../../domain/repositories/shipping_address_repository.dart';
import '../../data/repositories/shipping_address_repository_impl.dart';
import '../../../../core/utils/token_helper.dart';

class ShippingAddressViewModel with ChangeNotifier {
  final ShippingAddressRepository _repository;

  ShippingAddressModel? _shippingAddress;
  bool _isLoading = false;

  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  final countryController = TextEditingController();

  ShippingAddressViewModel({ShippingAddressRepository? repository})
      : _repository = repository ?? ShippingAddressRepositoryImpl();

  ShippingAddressModel? get shippingAddress => _shippingAddress;
  bool get isLoading => _isLoading;

  void populateControllers() {
    if (_shippingAddress != null) {
      phoneController.text = _shippingAddress!.phone ?? '';
      fullNameController.text = _shippingAddress!.fullName ?? '';
      emailController.text = _shippingAddress!.email ?? '';
      address1Controller.text = _shippingAddress!.address1 ?? '';
      address2Controller.text = _shippingAddress!.address2 ?? '';
      cityController.text = _shippingAddress!.city ?? '';
      stateController.text = _shippingAddress!.state ?? '';
      zipcodeController.text = _shippingAddress!.zipcode ?? '';
      countryController.text = _shippingAddress!.country ?? '';
    }
  }

  void clearForm() {
    phoneController.clear();
    fullNameController.clear();
    emailController.clear();
    address1Controller.clear();
    address2Controller.clear();
    cityController.clear();
    stateController.clear();
    zipcodeController.clear();
    countryController.clear();
  }

  Future<void> fetchShippingAddress() async {
    final token = await TokenHelper.getValidToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    _isLoading = true;
    notifyListeners();

    try {
      _shippingAddress = await _repository.fetchShippingAddress(token);
      populateControllers();
    } catch (e) {
      // Allow error handling
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveShippingAddress() async {
    await createOrUpdateShippingAddress(
      phone: phoneController.text,
      fullName: fullNameController.text,
      email: emailController.text,
      address1: address1Controller.text,
      address2: address2Controller.text,
      city: cityController.text,
      state: stateController.text,
      zipcode: zipcodeController.text,
      country: countryController.text,
    );
  }

  Future<void> createOrUpdateShippingAddress({
    String? phone,
    String? fullName,
    String? email,
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

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createOrUpdateShippingAddress(
        token,
        phone: phone,
        fullName: fullName,
        email: email,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        zipcode: zipcode,
        country: country,
      );
      _shippingAddress = await _repository.fetchShippingAddress(token);
      populateControllers();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipcodeController.dispose();
    countryController.dispose();
    super.dispose();
  }
}
