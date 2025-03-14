import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesNotifier extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _favorites = [];
  List<String> _ids = [];
  String? userId;

  List<String> get ids => _ids;
  List<Map<String, dynamic>> get favorites => _favorites;

  set ids(List<String> newIds) {
    _ids = newIds;
    notifyListeners();
  }

  set favorites(List<Map<String, dynamic>> newFavorites) {
    _favorites = newFavorites;
    notifyListeners();
  }

  void setUserId(String userId) {
    this.userId = userId;
    // Delay getFavorites() until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFavorites();
    });
  }

  Future<void> getFavorites() async {
    try {
      if (userId == null) {
        debugPrint('FavoritesNotifier: User ID is not set');
        return;
      }

      if (_auth.currentUser?.isAnonymous == true) {
        _favorites = [];
        _ids = [];
        notifyListeners();
        return;
      }

      QuerySnapshot favoritesSnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .get();

      _favorites =
          favoritesSnapshot.docs.map((doc) {
            return {
              "key": doc.id,
              "id": doc['id'] ?? "",
              "name": doc['name'] ?? "",
              "price": doc['price'] ?? 0.0,
              "image": doc['image'] ?? "",
              "category": doc['category'] ?? "",
            };
          }).toList();

      _ids = _favorites.map((item) => item['id'] as String).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('FavoritesNotifier: Error fetching favorites: $e');
    }
  }

  Future<void> deleteFav(String docId) async {
    try {
      if (userId == null) {
        debugPrint('FavoritesNotifier: User ID is not set');
        return;
      }

      if (_auth.currentUser?.isAnonymous == true) {
        debugPrint(
          'FavoritesNotifier: Anonymous users cannot delete favorites',
        );
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(docId)
          .delete();

      _favorites.removeWhere((item) => item['key'] == docId);
      _ids = _favorites.map((item) => item['id'] as String).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('FavoritesNotifier: Error deleting favorite: $e');
    }
  }

  Future<void> createFav(Map<String, dynamic> addFav) async {
    try {
      if (userId == null) {
        debugPrint('FavoritesNotifier: User ID is not set');
        return;
      }

      if (_auth.currentUser?.isAnonymous == true) {
        debugPrint('FavoritesNotifier: Anonymous users cannot add favorites');
        return;
      }

      bool exists = _favorites.any((item) => item['id'] == addFav['id']);
      if (!exists) {
        DocumentSnapshot productSnapshot =
            await _firestore.collection('products').doc(addFav['id']).get();

        if (productSnapshot.exists) {
          var productData = productSnapshot.data() as Map<String, dynamic>;

          DocumentReference newFav = await _firestore
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .add({
                'id': addFav['id'],
                'name': productData['name'],
                'price': productData['price'],
                'image': productData['image_url'],
                'category': productData['category'],
              });

          _favorites.add({
            'key': newFav.id,
            'id': addFav['id'],
            'name': productData['name'],
            'price': productData['price'],
            'image': productData['image_url'],
            'category': productData['category'],
          });

          _ids.add(addFav['id']);
          notifyListeners();
        } else {
          debugPrint(
            'FavoritesNotifier: Product not found in products collection',
          );
        }
      }
    } catch (e) {
      debugPrint('FavoritesNotifier: Error creating favorite: $e');
    }
  }
}
