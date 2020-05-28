import 'dart:math';

import "package:flutter/foundation.dart";
import './product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return double.parse(total.toStringAsFixed(2));
  }

  addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
            id: existingItem.id,
            productId: product.id,
            price: existingItem.price,
            quantity: existingItem.quantity + 1,
            title: existingItem.title),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          productId: product.id,
          id: Random().nextDouble().toString(),
          price: product.price,
          quantity: 1,
          title: product.title,
        ),
      );
    }

    notifyListeners();
  }

  removeItem(productId) {
    _items.remove(productId);

    notifyListeners();
  }

  removeSingleItem(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity == 1) {
      removeItem(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            productId: productId,
            title: existingItem.title,
            quantity: existingItem.quantity - 1,
            price: existingItem.price),
      );
    }

    notifyListeners();
  }

  clear() {
    _items = {};

    notifyListeners();
  }
}
