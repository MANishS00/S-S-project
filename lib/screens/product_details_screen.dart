// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    bool isOnSale = widget.product.isSale;
    double salePrice = widget.product.salePrice ?? 0.0;
    int availableStock = widget.product.stockQuantity;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: const Color(0xffF4EEFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.profileImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  if (isOnSale)
                    Row(
                      children: [
                        Text(
                          'Rs ${widget.product.price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Rs ${salePrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Rs ${widget.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Available stock: $availableStock',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Quantity: '),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton<int>(
                        value: _selectedQuantity,
                        items:
                            List.generate(availableStock, (index) => index + 1)
                                .map((quantity) => DropdownMenuItem(
                                      value: quantity,
                                      child: Text(quantity.toString()),
                                    ))
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedQuantity = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,width: 150,
                      child: ElevatedButton(
                        onPressed: _selectedQuantity <= availableStock
                            ? () {
                                cartProvider.addToCart(
                                    widget.product, _selectedQuantity);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Added to cart!',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            : null, // Disable button if quantity exceeds stock
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff024874),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Add to Cart',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
