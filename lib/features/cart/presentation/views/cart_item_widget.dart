import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cart_item_model.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context, listen: false);

    final price = cartItem.product.isSale
        ? cartItem.product.salePrice!
        : cartItem.product.price;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black45,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            /// Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cartItem.product.profileImage,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 15),

            /// Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Rs ${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Total: Rs ${(price * cartItem.quantity).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Quantity Controls
                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          cartVM.decrementItem(cartItem.product.id);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${cartItem.quantity}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _quantityButton(
                        icon: Icons.add,
                        onTap: () {
                          cartVM.incrementItem(cartItem.product.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Delete Button
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 28,
              ),
              onPressed: () {
                cartVM.removeFromCart(cartItem.product.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.green,
        ),
      ),
    );
  }
}
