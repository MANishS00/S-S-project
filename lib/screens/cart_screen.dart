import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart';
import 'checkout_screen.dart';
import 'home_page.dart';
import 'home_view/product_view.dart';
import 'auth_pages/login_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.values.toList();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xffF4EEFF),
      body: cartItems.isEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 150),
                      child: Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Color(0xffA6B1E1)),
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'You may also like',
                              style: TextStyle(
                                   fontSize: 20,color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProductsView(), // list the products
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            'Rs ${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineLarge
                                  ?.color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      CartItem cartItem = cartItems[index];
                      return CartItemWidget(cartItem: cartItem);
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: cartItems.isEmpty
            ? SizedBox(
          height: 50,
              child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff424874),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
                        ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: const Text('Continue Shopping',style: TextStyle(color: Colors.white),),
                ),
            )
            : SizedBox(
          height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff424874),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                  onPressed: () {
                    // Check if user is authenticated via AuthProvider
                    if (authProvider.isAuthenticated) {
                      // If authenticated, navigate to the checkout screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutScreen()),
                      );
                    } else {
                      // If not authenticated, navigate to the login screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  child: const Text('Proceed to Checkout',style: TextStyle(color: Colors.white),),
                ),
            ),
      ),
    );
  }
}
