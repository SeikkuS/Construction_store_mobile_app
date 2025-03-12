import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  set cart(List<Map<String, dynamic>> newCart) {
    _cart = newCart;
    notifyListeners();
  }

  // Fetch the cart items from Firestore
  Future<void> getCart() async {
    try {
      QuerySnapshot cartSnapshot = await _firestore.collection('cart').get();
      _cart =
          cartSnapshot.docs.map((doc) {
            return {
              "key": doc.id, // Firestore doc ID as key
              "id": doc['id'], // This will be the product ID (e.g., 'ruuvi1')
              "category": doc['category'],
              "name": doc['name'],
              "price": doc['price'],
              "qty": doc['qty'],
              "image": doc['image'],
            };
          }).toList();

      _cart =
          _cart.reversed
              .toList(); // Optional: Reversing the order of the cart items
      notifyListeners();
    } catch (e) {
      print('Error fetching cart: $e');
    }
  }

  // Delete an item from the cart in Firestore
  Future<void> deleteCart(String key) async {
    try {
      await _firestore.collection('cart').doc(key).delete();
      _cart.removeWhere((item) => item['key'] == key);
      notifyListeners();
    } catch (e) {
      print('Error deleting cart item: $e');
    }
  }

  // Add a new item to the cart in Firestore
  Future<void> addToCart(Map<String, dynamic> cartItem) async {
    try {
      // Ensure the product ID ('id' from product) is used as the document ID
      await _firestore.collection('cart').doc(cartItem['id']).set({
        "category": cartItem['category'],
        "id":
            cartItem['id'], // This should now correctly store 'ruuvi1' as 'id'
        "image": cartItem['image'],
        "name": cartItem['name'],
        "price": cartItem['price'],
        "qty": cartItem['qty'],
      });

      // Update the local cart list
      _cart.add(cartItem);
      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // Increment quantity for an item in the cart
  Future<void> incrementQty(String key) async {
    var itemIndex = _cart.indexWhere((item) => item['key'] == key);
    if (itemIndex != -1) {
      var updatedItem = _cart[itemIndex];
      updatedItem['qty']++;
      await _firestore.collection('cart').doc(key).update({
        'qty': updatedItem['qty'],
      });
      _cart[itemIndex] = updatedItem;
      notifyListeners();
    }
  }

  // Decrement quantity for an item in the cart
  Future<void> decrementQty(String key) async {
    var itemIndex = _cart.indexWhere((item) => item['key'] == key);
    if (itemIndex != -1) {
      var updatedItem = _cart[itemIndex];
      if (updatedItem['qty'] > 1) {
        updatedItem['qty']--;
        await _firestore.collection('cart').doc(key).update({
          'qty': updatedItem['qty'],
        });
        _cart[itemIndex] = updatedItem;
        notifyListeners();
      }
    }
  }
}
