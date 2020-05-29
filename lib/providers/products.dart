import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/constantes/constantes.dart';
import 'package:shop/exceptions/http_exception.dart';
import '../providers/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [];
  final _baseUrl = "${Constantes.BASE_API_URL}/products";
  List<Product> get items => [..._items];

  List<Product> get itemsFavorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();

    if (data != null) {
      data.forEach((productId, productData) {
        // print(productData);
        _items.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'] != null ?? productData['isFavorite']
        ));
      });
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProducts(Product newProduct) async {
    final response = await http.post("$_baseUrl.json",
        body: json.encode({
          "title": newProduct.title,
          "description": newProduct.description,
          "price": newProduct.price,
          "imageUrl": newProduct.imageUrl,
        }));

    _items.add(Product(
      id: json.decode(response.body)['nome'],
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));

    notifyListeners();
  }

  updateProduct(Product prod) async {
    if (prod == null || prod.id == null) {
      return;
    }

    final index = _items.indexWhere((element) => element.id == prod.id);
    if (index >= 0) {
      await http.patch("$_baseUrl/${prod.id}.json",
          body: json.encode({
            "title": prod.title,
            "price": prod.price,
            "description": prod.description,
            "imageUrl": prod.imageUrl,
          }));
      _items[index] = prod;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final product = _items[index];

      _items.remove(product);
      notifyListeners();
      
      final response = await http.delete("$_baseUrl/${product.id}.json");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException("Ocorreu um erro ao excluir o produto");
      }
    }
  }
}
