import '../../data/models/shipping_address_model.dart';

abstract class ShippingAddressRepository {
  Future<ShippingAddressModel?> fetchShippingAddress(String token);
  Future<void> createOrUpdateShippingAddress(
    String token, {
    String? phone,
    String? fullName,
    String? email,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? zipcode,
    String? country,
  });
}
