import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {
  final _cartBox = Hive.box('cart_box');
  List<dynamic> _cart = [];

  List<dynamic> get cart => _cart;

  set cart(List<dynamic> newCart) {
    _cart = newCart;
    notifyListeners();
  }

  getCart() {
    final cartData =
        _cartBox.keys.map((key) {
          final item = _cartBox.get(key);

          return {
            "key": key,
            "id": item['id'],
            "category": item['category'],
            "name": item['name'],
            "price": item['price'],
            "qty": item['qty'],
            "image": item['image'],
            "sizes": item['sizes'],
          };
        }).toList();

    _cart = cartData.reversed.toList();
  }

  Future<void> deleteCart(int key) async {
    await _cartBox.delete(key);
  }

  int _counter = 0;

  int get counter => _counter;

  void increment() {}

  void decrement() {}
}
