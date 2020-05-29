import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/products.dart';
import '../utils/app_routes.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUCTS_FORM, arguments: product);
                },
              ),
              IconButton(
                color: Theme.of(context).errorColor,
                icon: Icon(Icons.delete),
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text("Tem certeza?"),
                            content: Text("Deseja deletar esse produto?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Não"),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              )
                            ],
                          )).then((value) async {
                    if (value)
                      try {
                        await Provider.of<Products>(context, listen: false).deleteProduct(product.id);
                      } on HttpException catch (error) {
                        scaffold.showSnackBar(SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(error.toString()),
                        ));
                      }
                  });
                },
              )
            ],
          )),
    );
  }
}
