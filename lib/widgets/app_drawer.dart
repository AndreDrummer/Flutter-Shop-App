import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
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
                    AppRoutes.AUTH_HOME_SCREEN,
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
              Divider(),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Gerenciador de Produtos"),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.PRODUCTS,
                  );
                },
              ),              
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Sair"),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                },
              ),
              Divider()
            ],
          )),
    );
  }
}
