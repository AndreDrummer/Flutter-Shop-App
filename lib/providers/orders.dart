import 'dart:convert';
import "package:flutter/foundation.dart";
import 'package:http/http.dart' as http;
import './cart.dart';
import '../constantes/constantes.dart';

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
  String _token;
  String _userId;
  List<Order> get items => [..._items];

  Orders([this._token, this._userId, this._items = const []]);

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final _baseUrl = "${Constantes.BASE_API_URL}/orders/$_userId.json?auth=$_token";
    final date = DateTime.now();
    final response = await http.post(
      _baseUrl,
      body: json.encode({
        "total": cart.totalAmount,
        "date": date.toIso8601String(),
        "products": cart.items.values
            .map((cartItem) => {
                  "id": cartItem.id,
                  "productId": cartItem.productId,
                  "title": cartItem.title,
                  "price": cartItem.price,
                  "quantity": cartItem.quantity,
                })
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
          id: json.decode(response.body)['name'],
          date: date,
          products: cart.items.values.toList(),
          total: cart.totalAmount),
    );

    notifyListeners();
  }

  Future<void> loadOrders() async {
    final _baseUrl = "${Constantes.BASE_API_URL}/orders/$_userId.json?auth=$_token";
    final response = await http.get(_baseUrl);
    Map<String, dynamic> order = json.decode(response.body);

    _items.clear();

    order.forEach((orderId, orderData) => {
          _items.add(Order(
              id: orderId,
              date: DateTime.parse(orderData['date']),
              total: orderData['total'],
              products: (orderData['products'] as List<dynamic>).map((product) {
                return CartItem(
                  id: product['id'],
                  productId: product['productId'],
                  title: product['title'],
                  price: product['price'],
                  quantity: product['quantity'],
                );
              }).toList()))
        });

    notifyListeners();
  }
}
