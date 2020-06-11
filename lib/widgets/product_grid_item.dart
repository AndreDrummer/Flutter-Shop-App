import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
import '../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Product product = Provider.of(context, listen: false);
     Cart cart = Provider.of(context, listen: false);
     Auth auth = Provider.of(context, listen: false);    

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCTS_DETAIL,
                arguments: product,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  try {
                    await product.toggleFavorite(product.id, auth.token, auth.userId);
                  } catch (error) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(error.toString()),
                      ),
                    );
                  }
                },
              ),
            ),            
            title: Text(product.title),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text("Item adicionado com sucesso!"),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
                cart.addItem(product);
              },
            ),
          )),
    );
  }
}
