import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item_widget.dart';

import "../providers/orders.dart";

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final orders =  Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos")
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (_, i) => OrderItemWidget(orders.items[i]),
      ),
    );
  }
}