import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// packages
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/productsScreen.dart';
import 'package:shop/views/products_form_screen.dart';

// telas
import './views/products_detail_screen.dart';
import './views/auth_screen.dart';

// providiers
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        )
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        debugShowCheckedModeBanner: false,
        // home: AuthScreen(),
        routes: {
          AppRoutes.AUTH: (ctx) => AuthScreen(),
          AppRoutes.HOME: (ctx) => ProductDetailScreen(),
          AppRoutes.PRODUCTS_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCTS_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
