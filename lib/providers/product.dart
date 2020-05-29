import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/constantes/constantes.dart';
import 'package:shop/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(product) async {
    const _baseUrl = "${Constantes.BASE_API_URL}/products";

    this.isFavorite = !this.isFavorite;
    notifyListeners();

    final response = await http.patch("$_baseUrl/${product.id}.json", body: json.encode({ 
      "isFavorite": this.isFavorite,
    }));

    if (response.statusCode >= 400) {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
      throw HttpException("Erro ao favoritaro ou desfavoritar item");
    }
  }
}
