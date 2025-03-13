import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _cart = [];
  String? userId; // Store the user's ID (e.g., from authentication)

  List<Map<String, dynamic>> get cart => _cart;

  set cart(List<Map<String, dynamic>> newCart) {
    _cart = newCart;
    notifyListeners();
  }

  // Set the user ID and fetch cart immediately
  void setUserId(String userId) {
    this.userId = userId;
    getCart(); // Fetch cart to sync local state
  }

  // Fetch the cart items from Firestore for the authenticated user
  Future<void> getCart() async {
    try {
      if (userId == null) {
        debugPrint('CartProvider: User ID is not set');
        return;
      }

      QuerySnapshot cartSnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get();

      _cart =
          cartSnapshot.docs.map((doc) {
            return {
              "key": doc.id, // Firestore doc ID as key
              "id": doc['id'],
              "category": doc['category'],
              "name": doc['name'],
              "price": doc['price'],
              "qty": doc['qty'],
              "image": doc['image'],
            };
          }).toList();

      _cart = _cart.reversed.toList();
      notifyListeners();
    } catch (e) {
      debugPrint('CartProvider: Error fetching cart: $e');
    }
  }

  // Delete an item from the cart in Firestore
  Future<void> deleteFromCart(String key) async {
    try {
      if (userId == null) {
        debugPrint('CartProvider: User ID is not set');
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(key)
          .delete();

      _cart.removeWhere((item) => item['key'] == key);
      notifyListeners();
    } catch (e) {
      debugPrint('CartProvider: Error deleting cart item: $e');
    }
  }

  // Add a new item to the cart in Firestore for the user
  Future<void> addToCart(Map<String, dynamic> cartItem) async {
    try {
      if (userId == null) {
        debugPrint('CartProvider: User ID is not set');
        return;
      }

      // Check if the item already exists in the cart
      var existingItemIndex = _cart.indexWhere(
        (item) => item['id'] == cartItem['id'],
      );
      if (existingItemIndex != -1) {
        // If it exists, increment the quantity
        await incrementQty(_cart[existingItemIndex]['key']);
      } else {
        // If it doesn’t exist, add a new item
        DocumentReference newCartItem = await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .add({
              "category": cartItem['category'],
              "id": cartItem['id'],
              "image": cartItem['image'],
              "name": cartItem['name'],
              "price": cartItem['price'],
              "qty": cartItem['qty'],
            });

        _cart.add({
          "key": newCartItem.id,
          "id": cartItem['id'],
          "category": cartItem['category'],
          "name": cartItem['name'],
          "price": cartItem['price'],
          "qty": cartItem['qty'],
          "image": cartItem['image'],
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('CartProvider: Error adding to cart: $e');
    }
  }

  // Increment quantity for an item in the cart
  Future<void> incrementQty(String key) async {
    try {
      var itemIndex = _cart.indexWhere((item) => item['key'] == key);
      if (itemIndex != -1) {
        var updatedItem = Map<String, dynamic>.from(_cart[itemIndex]);
        updatedItem['qty']++;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(key)
            .update({'qty': updatedItem['qty']});
        _cart[itemIndex] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('CartProvider: Error incrementing quantity: $e');
    }
  }

  // Decrement quantity for an item in the cart
  Future<void> decrementQty(String key) async {
    try {
      var itemIndex = _cart.indexWhere((item) => item['key'] == key);
      if (itemIndex != -1) {
        var updatedItem = Map<String, dynamic>.from(_cart[itemIndex]);
        if (updatedItem['qty'] > 1) {
          updatedItem['qty']--;
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .doc(key)
              .update({'qty': updatedItem['qty']});
          _cart[itemIndex] = updatedItem;
          notifyListeners();
        } else {
          // Remove the item if quantity would drop to 0
          await deleteFromCart(key);
        }
      }
    } catch (e) {
      debugPrint('CartProvider: Error decrementing quantity: $e');
    }
  }
}
