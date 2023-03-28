import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<cartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.dateTime,
      required this.id,
      required this.products,
      required this.amount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _Orders = [];

  List<OrderItem> get orders {
    return [..._Orders];
  }

  Future<void> fetchAndSetOrder() async {
    const url =
        'https://shop-app-3bd1d-default-rtdb.firebaseio.com/orders.json';

    final response = await http.get(Uri.parse(url));
    List<OrderItem> loadedorder = [];
    final excratedorders = jsonDecode(response.body) as Map<String, dynamic>;
    if(excratedorders == null){
      return;
    }
    excratedorders.forEach((orderID, orderData) {
      loadedorder.add(OrderItem(
          dateTime: DateTime.parse(orderData['dataTime']),
          id: orderID,
          products: (orderData['products'] as List<dynamic>)
              .map((item) => cartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
          amount: orderData['amount']));
      _Orders=loadedorder.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addorder(List<cartItem> cartProducts, double total) async {
    const url =
        'https://shop-app-3bd1d-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: jsonEncode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cartprod) => {
                    'id': cartprod.id,
                    'title': cartprod.title,
                    'quantity': cartprod.quantity,
                    'price': cartprod.price,
                  })
              .toList(),
        }));

    _Orders.insert(
        0,
        OrderItem(
            dateTime: DateTime.now(),
            id: jsonDecode(response.body)['name'],
            products: cartProducts,
            amount: total));
    notifyListeners();
  }
}
