import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cart_item_model.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartVM = Provider.of<CartViewModel>(context, listen: false);

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
            fit: BoxFit.cover,
          ),
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
                  cartVM.decrementItem(cartItem.product.id);
                },
                color: Theme.of(context).primaryColor,
                tooltip: 'Decrease Quantity',
              ),
              Container(
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${cartItem.quantity}'),
                  )),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  cartVM.incrementItem(cartItem.product.id);
                },
                color: Theme.of(context).primaryColor,
                tooltip: 'Add Quantity',
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  cartVM.removeFromCart(cartItem.product.id);
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
