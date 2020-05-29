import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shop/widgets/cart_item_widget.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      "R\$ ${cart.totalAmount}",
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  Spacer(),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, i) => CartItemWidegt(cartItem: cartItems[i]),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : FlatButton(
            child: Text(
              "COMPRAR",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: widget.cart.totalAmount == 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    await Provider.of<Orders>(context, listen: false)
                        .addOrder(widget.cart);
                    widget.cart.clear();

                    setState(() {
                      _isLoading = false;
                    });
                  },
          );
  }
}
