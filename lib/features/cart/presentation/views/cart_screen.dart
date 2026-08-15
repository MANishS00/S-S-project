import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/checkout/presentation/views/widgets/status.dart';
import 'package:app/features/profile/presentation/viewmodels/shipping_address_viewmodel.dart';
import 'package:app/features/profile/presentation/views/shipping_address_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
// import '../../data/models/cart_item_model.dart';
import 'cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isNavigating = false;
  @override
  void initState() {
    super.initState();
    _loadShippingAddress();
  }

  Future<void> _loadShippingAddress() async {
    final shippingVM =
        Provider.of<ShippingAddressViewModel>(context, listen: false);
    await shippingVM.fetchShippingAddress();
  }
 

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartViewModel>();
    final cartItems = cartVM.cartItems.values.toList();
    final authViewModel = context.read<AuthViewModel>();
    final shippingVM = Provider.of<ShippingAddressViewModel>(context);
    final shippingAddress = shippingVM.shippingAddress;
    if (cartItems.isEmpty && !_isNavigating) {
      _isNavigating = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed('/home');
      });

      return const Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox.expand(), // Nothing is painted, so no blink.
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: shippingAddress != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusWidget(currentStep: 1),
            const Divider(color: Colors.black12, thickness: 1),
            const SizedBox(height: 18),
            if (shippingAddress != null) ...[
              Column(
                children: [
                  Text(
                    'Please Check your shipping address before proceeding',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${shippingAddress.address1 ?? ''}, '
                                        '${shippingAddress.address2 ?? ''}, '
                                        '${shippingAddress.city ?? ''}, '
                                        '${shippingAddress.state ?? ''}, '
                                        '${shippingAddress.zipcode ?? ''}, '
                                        '${shippingAddress.country ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShippingAddressForm(),
                                ),
                              ).then((_) => _loadShippingAddress());
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ] else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Shipping Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_location_alt,
                        color: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShippingAddressForm(),
                        ),
                      ).then((_) => _loadShippingAddress());
                    },
                  ),
                ],
              ),
            const SizedBox(height: 20),
            const Text('Order Summary', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (ctx, index) {
                  final cartItem = cartItems[index];
                  return CartItemWidget(cartItem: cartItem);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Rs ${cartVM.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    if (authViewModel.isAuthenticated) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const CheckoutScreen()),
                      // );
                    } else {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const LoginScreen()),
                      // );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 50,
                    // width: 150,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    child: const Center(
                      child: Text(
                        "Proceed to Checkout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        extendBody: true,

    );
  }
}
