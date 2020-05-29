import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item_widget.dart';

import "../providers/orders.dart";

class OrdersScreen extends StatelessWidget {
  Future<void> _refreshOrder(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
        appBar: AppBar(title: Text("Meus Pedidos")),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).loadOrders(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Ocorreu um erro!"));
            } else {
              return RefreshIndicator(
                onRefresh: () => _refreshOrder(context),
                child: Consumer<Orders>(
                  builder: (context, orders, child) {
                    return ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (_, i) => OrderItemWidget(orders.items[i]));
                  },                                  
                  ),
                );              
            }
          },
        ));
  }
}
