import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
        appBar: AppBar(title: Text(product.title)),
        body: SingleChildScrollView(
          child: Column(            
            children: <Widget>[
              Container(                
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
                height: 300,
                width: double.infinity,
              ),
              SizedBox(height: 10),
              Text("R\$ ${product.price}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey)),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${product.description}",
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
