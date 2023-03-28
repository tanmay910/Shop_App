import 'package:flutter/cupertino.dart';
import 'package:shop_app/widgets/cart_item.dart';

class cartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  cartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, cartItem> _items = {};

  Map<String, cartItem> get item {
    return {..._items};
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => cartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => cartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartitem) {
      total += cartitem.price * cartitem.quantity;
    });
    return total;
  }

  void removeItem(String ProductId) {
    _items.remove(ProductId);
    notifyListeners();
  }

  void removeSingleItem(String ProductId) {
    if (_items.containsKey(ProductId) == false) {
      return;
    } else if ((_items[ProductId]?.quantity ?? 0) > 1) {
      _items.update(
          ProductId,
          (Existingitem) => cartItem(
              id: Existingitem.id,
              title: Existingitem.title,
              price: Existingitem.price,
              quantity: Existingitem.quantity - 1));
    }
    else {
      _items.remove(ProductId);
    }
    notifyListeners();
  }

  int get itemcount {
    return _items.length;
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
