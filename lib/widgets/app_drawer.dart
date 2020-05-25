import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Bem vindo usuário!"),
          ),
          body: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.shop),
                title: Text("Loja"),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.HOME,
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text("Meus Pedidos"),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.ORDERS,
                  );
                },
              ),
              Divider()
            ],
          )),
    );
  }
}
