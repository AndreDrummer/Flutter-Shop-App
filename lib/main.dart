import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';
import './views/products_overview_screen.dart';
import './views/products_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Loja',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato'
      ),
      home: ProductsOverviewScreen(),
      routes: {
        AppRoutes.PRODUCTS_DETAIL: (ctx) => ProductDetailScreen()
      },
    );
  }
}