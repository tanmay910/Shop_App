import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false,
      required this.title});

  void toggleFavourite() async{
    final oldstate = isFavorite;
    this.isFavorite = !this.isFavorite;
    notifyListeners();
    try {
      final url =
          'https://shop-app-3bd1d-default-rtdb.firebaseio.com/products/$id.json';
     final response= await http.patch(Uri.parse(url),
          body: jsonEncode({
            'isFavorite': isFavorite,
          }));
      if(response.statusCode >=400){
        isFavorite= oldstate;
        notifyListeners();

      }
    } catch (error) {
      isFavorite= oldstate;
      notifyListeners();

    }
  }
}
