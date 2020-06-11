import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import './products_overview_screen.dart';
import '../views/auth_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return FutureBuilder(
          future: auth.tryAutoLogin(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Ocorreu um erro! ${snapshot.error}"));
            } else {
              return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
            }
          },
        );
      },
    );
  }
}
