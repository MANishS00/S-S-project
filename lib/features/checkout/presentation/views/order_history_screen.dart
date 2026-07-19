import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/checkout_viewmodel.dart';
import '../../../product/presentation/viewmodels/product_viewmodel.dart';
import '../../../product/presentation/views/product_details_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CheckoutViewModel>(context, listen: false).fetchOrderHistory();
    });
  }

  Future<void> _openProductDetails(int productId) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final productVM = Provider.of<ProductViewModel>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final product = await productVM.fetchProductById(productId);
      navigator.pop(); // dismiss loading dialog

      if (product != null) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Product details for ID #$productId not found.')),
        );
      }
    } catch (e) {
      navigator.pop(); // dismiss loading dialog
      messenger.showSnackBar(
        SnackBar(content: Text('Error loading product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutVM = Provider.of<CheckoutViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: checkoutVM.isLoading && checkoutVM.orderHistory.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : checkoutVM.orderHistory.isEmpty
              ? const Center(
                  child: Text(
                    'No orders placed yet.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: checkoutVM.orderHistory.length,
                  itemBuilder: (context, index) {
                    final order = checkoutVM.orderHistory[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.id}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    order.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: order.status.toLowerCase() == 'delivered'
                                      ? Colors.green
                                      : order.status.toLowerCase() == 'shipped'
                                          ? Colors.blue
                                          : Colors.orange,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Date: ${order.dateOrdered != null ? order.dateOrdered!.toLocal().toString().substring(0, 10) : "N/A"}'),
                            Text('Total Amount: Rs ${order.amountPaid.toStringAsFixed(2)}'),
                            Text('Payment Method: ${order.paymentMethod}'),
                            Text('Shipping Address: ${order.shippingAddress}'),
                            if (order.trackingNumber.isNotEmpty)
                              Text('Tracking #${order.trackingNumber} (${order.courierService})'),
                            const Divider(height: 24),
                            const Text(
                              'Order Items (Tap to view product):',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: order.items.map((item) {
                                return Card(
                                  color: const Color(0xffF4EEFF),
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: const Icon(Icons.shopping_bag, color: Color(0xff424874)),
                                    title: Text('Product ID #${item.productId}'),
                                    subtitle: Text('Qty: ${item.quantity}  |  Price: Rs ${item.price.toStringAsFixed(2)}'),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () => _openProductDetails(item.productId),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
