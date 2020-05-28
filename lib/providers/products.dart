import 'dart:math';

import 'package:flutter/foundation.dart';
import '../providers/product.dart';
import 'package:shop/data/dummy_data.dart';

class Products with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  List<Product> get itemsFavorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  addProducts(Product newProduct) {
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));

    notifyListeners();
  }

  updateProduct(Product prod) {
    if (prod == null || prod.id == null) {
      return;
    }

    final index = _items.indexWhere((element) => element.id == prod.id);
    if (index >= 0) {
      _items[index] = prod;
      notifyListeners();
    }
  }

  deleteProduct(String id) {  
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id== id);
      notifyListeners();
    }
  }
}
