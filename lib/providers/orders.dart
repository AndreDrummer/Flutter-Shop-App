import 'dart:math';
import "package:flutter/foundation.dart";

import './cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    @required this.id,
    @required this.total,
    @required this.products,
    @required this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  addOrder(Cart cart) {
    _items.insert(
      0,
      Order(
          id: Random().nextDouble().toString(),
          date: DateTime.now(),
          products: cart.items.values.toList(),
          total: cart.totalAmount),
    );

    notifyListeners();
  }
}
