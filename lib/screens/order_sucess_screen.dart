import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  // final double totalAmount;
  // final List<Map<String, dynamic>> orderedItems;
  // final Map<String, dynamic> shippingAddress;

  // OrderSuccessScreen({
  //   required this.totalAmount,
  //   required this.orderedItems,
  //   required this.shippingAddress,
  // });

  @override
  Widget build(BuildContext context) {
    // final formattedShippingAddress =
    //     '${shippingAddress['phone']}, ${shippingAddress['address1']}, '
    //     '${shippingAddress['address2']}, ${shippingAddress['city']}, '
    //     '${shippingAddress['state']} ${shippingAddress['zipcode']}, ${shippingAddress['country']}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Success'),
        automaticallyImplyLeading: false, // Prevents back navigation
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for your purchase!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your order has been placed successfully.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Navigate back to the main screen or home
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
