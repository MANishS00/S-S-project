import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/shipping_address_model.dart';
import '../../domain/repositories/shipping_address_repository.dart';
import '../../data/repositories/shipping_address_repository_impl.dart';
import '../../../../core/utils/token_helper.dart';

class ShippingAddressViewModel with ChangeNotifier {
  final ShippingAddressRepository _repository;

  ShippingAddressModel? _shippingAddress;

  ShippingAddressViewModel({ShippingAddressRepository? repository})
      : _repository = repository ?? ShippingAddressRepositoryImpl();

  ShippingAddressModel? get shippingAddress => _shippingAddress;

  Future<void> fetchShippingAddress() async {
    final token = await TokenHelper.getValidToken();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    try {
      _shippingAddress = await _repository.fetchShippingAddress(token);
      notifyListeners();
    } catch (e) {
      // // rethrow;
    }
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
      await fetchShippingAddress();
    } catch (e) {
      // rethrow;
    }
  }
}
