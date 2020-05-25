import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../providers/cart.dart';

class CartItemWidegt extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidegt({@required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.productId);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: FittedBox(child: Text("${cartItem.price}")),
            ),
            title: Text("${cartItem.title}"),
            subtitle: Text(
                "Total: ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}"),
            trailing: Text("${cartItem.quantity}x"),
          ),
        ),
      ),
    );
  }
}
