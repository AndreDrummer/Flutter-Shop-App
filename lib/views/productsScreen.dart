import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_item.dart';
import '../utils/app_routes.dart';

import '../providers/products.dart';

class ProductsScreen extends StatelessWidget {
  Future<void> _refreshProduct(context) {
    return Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciador de produtos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productsData.itemsCount,
              itemBuilder: (ctx, i) => Column(
                    children: <Widget>[ProductItem(products[i]), Divider()],
                  )),
        ),
      ),
    );
  }
}
