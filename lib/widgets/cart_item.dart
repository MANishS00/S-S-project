// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ListTile(
          leading: Image.network(
            cartItem.product.profileImage,
            width: 50,
            // height: 50,
            fit: BoxFit.cover,
          ),
          // leading: CircleAvatar(
          //   backgroundImage: NetworkImage(cartItem.product.profileImage),
          // ),
          title: Text(
            cartItem.product.name,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            maxLines: 2,
          ),
          subtitle: Text(
            'Total: Rs ${(cartItem.product.isSale ? cartItem.product.salePrice! * cartItem.quantity : cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  cartProvider.decrementItem(cartItem.product.id);
                },
                color: Theme.of(context).primaryColor,
                tooltip: 'Decrease Quantity',
              ),
              Container(
                  decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${cartItem.quantity}'),
                  )),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  cartProvider.incrementItem(cartItem.product.id);
                },
                color: Theme.of(context).primaryColor,
                tooltip: 'Add Quantity',
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  cartProvider.removeFromCart(cartItem.product.id);
                },
                color: Theme.of(context).colorScheme.error,
                tooltip: 'Remove Item from cart',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
