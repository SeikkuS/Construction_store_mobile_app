import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _cart = [];
  String? userId;

  List<Map<String, dynamic>> get cart => _cart;

  set cart(List<Map<String, dynamic>> newCart) {
    _cart = newCart;
    notifyListeners();
  }

  void setUserId(String userId) {
    this.userId = userId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCart();
    });
  }

  Future<void> getCart() async {
    try {
      if (userId == null) {
        debugPrint('CartProvider: User ID is not set');
        return;
      }

      if (_auth.currentUser?.isAnonymous == true) {
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
              "key": doc.id,
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

  Future<void> deleteFromCart(String key) async {
    try {
      if (userId == null) {
        debugPrint('CartProvider: User ID is not set');
        return;
      }

      if (_auth.currentUser?.isAnonymous == true) {
        _cart.removeWhere((item) => item['key'] == key);
        notifyListeners();
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

  Future<void> addToCart(Map<String, dynamic> cartItem) async {
    try {
      if (userId == null) {
        debugPrint('CartProvider: User ID is not set');
        return;
      }

      var existingItemIndex = _cart.indexWhere(
        (item) => item['id'] == cartItem['id'],
      );
      if (existingItemIndex != -1) {
        // Item exists, add the cartItem's qty to the existing qty
        var updatedItem = Map<String, dynamic>.from(_cart[existingItemIndex]);
        updatedItem['qty'] += cartItem['qty'];
        if (_auth.currentUser?.isAnonymous == true) {
          _cart[existingItemIndex] = updatedItem;
          notifyListeners();
        } else {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .doc(updatedItem['key'])
              .update({'qty': updatedItem['qty']});
          _cart[existingItemIndex] = updatedItem;
          notifyListeners();
        }
      } else {
        if (_auth.currentUser?.isAnonymous == true) {
          _cart.add({
            "key": UniqueKey().toString(),
            "id": cartItem['id'],
            "category": cartItem['category'],
            "name": cartItem['name'],
            "price": cartItem['price'],
            "qty": cartItem['qty'],
            "image": cartItem['image'],
          });
          notifyListeners();
        } else {
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
      }
    } catch (e) {
      debugPrint('CartProvider: Error adding to cart: $e');
    }
  }

  Future<void> incrementQty(String key) async {
    try {
      var itemIndex = _cart.indexWhere((item) => item['key'] == key);
      if (itemIndex != -1) {
        var updatedItem = Map<String, dynamic>.from(_cart[itemIndex]);
        updatedItem['qty']++;
        if (_auth.currentUser?.isAnonymous == true) {
          _cart[itemIndex] = updatedItem;
          notifyListeners();
        } else {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .doc(key)
              .update({'qty': updatedItem['qty']});
          _cart[itemIndex] = updatedItem;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('CartProvider: Error incrementing quantity: $e');
    }
  }

  Future<void> decrementQty(String key) async {
    try {
      var itemIndex = _cart.indexWhere((item) => item['key'] == key);
      if (itemIndex != -1) {
        var updatedItem = Map<String, dynamic>.from(_cart[itemIndex]);
        if (updatedItem['qty'] > 1) {
          updatedItem['qty']--;
          if (_auth.currentUser?.isAnonymous == true) {
            _cart[itemIndex] = updatedItem;
            notifyListeners();
          } else {
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('cart')
                .doc(key)
                .update({'qty': updatedItem['qty']});
            _cart[itemIndex] = updatedItem;
            notifyListeners();
          }
        } else {
          await deleteFromCart(key);
        }
      }
    } catch (e) {
      debugPrint('CartProvider: Error decrementing quantity: $e');
    }
  }
}
