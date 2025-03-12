import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesNotifier extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _favorites = [];
  List<String> _ids = [];

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

  // Fetch favorites list from Firestore
  Future<void> getFavorites() async {
    try {
      QuerySnapshot favoritesSnapshot =
          await _firestore.collection('favorites').get();

      // Debugging: check the snapshot length
      print("Fetched favorites: ${favoritesSnapshot.docs.length} items");

      // Populate the favorites list with detailed data from Firestore
      _favorites =
          favoritesSnapshot.docs.map((doc) {
            return {
              "key": doc.id, // Firestore doc ID as key
              "id": doc['id'] ?? "",
              "name": doc['name'] ?? "",
              "price": doc['price'] ?? 0.0,
              "image": doc['image'] ?? "", // Ensure image URL or asset is valid
              "category": doc['category'] ?? "",
            };
          }).toList();

      // Debugging: check the populated _favorites
      print("Favorites after mapping: $_favorites");

      // Update the list of IDs as well
      _ids = _favorites.map((item) => item['id'] as String).toList();

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  // Delete a favorite item from Firestore
  Future<void> deleteFav(String docId) async {
    try {
      // Deleting the favorite from Firestore using the document ID
      await _firestore.collection('favorites').doc(docId).delete();

      // Remove the deleted item from the local list
      _favorites.removeWhere((item) => item['key'] == docId);

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print('Error deleting favorite: $e');
    }
  }

  // Create or add a favorite item to Firestore
  Future<void> createFav(Map<String, dynamic> addFav) async {
    try {
      bool exists = _favorites.any((item) => item['id'] == addFav['id']);
      if (!exists) {
        DocumentSnapshot productSnapshot =
            await _firestore.collection('products').doc(addFav['id']).get();

        if (productSnapshot.exists) {
          var productData = productSnapshot.data() as Map<String, dynamic>;

          DocumentReference
          newFav = await _firestore.collection('favorites').add({
            'id': addFav['id'],
            'name': productData['name'],
            'price': productData['price'],
            'image':
                productData['image_url'], // Use 'image_url' instead of 'image'
            'category': productData['category'],
          });

          _favorites.add({
            'key': newFav.id,
            'id': addFav['id'],
            'name': productData['name'],
            'price': productData['price'],
            'image':
                productData['image_url'], // Use 'image_url' instead of 'image'
            'category': productData['category'],
          });

          _ids.add(addFav['id']);
          notifyListeners();
        } else {
          print('Product not found in the products collection');
        }
      }
    } catch (e) {
      print('Error creating favorite: $e');
    }
  }
}
