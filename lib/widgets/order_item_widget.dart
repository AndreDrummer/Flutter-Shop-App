import 'package:flutter/material.dart';
import "package:intl/intl.dart";

import "../providers/orders.dart";

class OrderItemWidget extends StatefulWidget {
  final Order order;
  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeight = (widget.order.products.length * 25.0) + 10;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _isExpanded ? itemsHeight + 95 :95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("R\$ ${widget.order.total}"),
              subtitle:
                  Text(DateFormat("dd/MM/yyyy hh:mm").format(widget.order.date)),
              trailing: IconButton(
                icon: Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),            
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height:  _isExpanded ? itemsHeight : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: widget.order.products.map((product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${product.quantity}x ${product.price}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
