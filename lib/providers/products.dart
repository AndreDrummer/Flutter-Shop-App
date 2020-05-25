import 'package:flutter/foundation.dart';
import '../providers/product.dart';
import 'package:shop/data/dummy_data.dart';

class Products with ChangeNotifier {  

  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  List<Product> get itemsFavorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  addProducts(Product product) {
    _items.add(product);

    notifyListeners();
  } 
}