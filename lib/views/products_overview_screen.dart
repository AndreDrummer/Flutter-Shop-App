import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../widgets/productGrid.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).loadProducts().then(
          (value) => setState(() {
            _isLoading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Loja"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions option) {
              setState(() {
                if (option == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Somente Favoritos"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Todos"),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.CART,
                );
              },
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
