import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_store_mobile_app/models/product_model.dart';

class Helper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch Ruuvit products from Firestore by category filter
  Future<List<Products>> getRuuvit() async {
    QuerySnapshot snapshot =
        await _firestore
            .collection('products')
            .where('category', isEqualTo: 'Ruuvit')
            .get();

    return snapshot.docs.map((doc) => Products.fromFirestore(doc)).toList();
  }

  // Fetch Pultit products from Firestore by category filter
  Future<List<Products>> getPultit() async {
    QuerySnapshot snapshot =
        await _firestore
            .collection('products')
            .where('category', isEqualTo: 'Pultit')
            .get();

    return snapshot.docs.map((doc) => Products.fromFirestore(doc)).toList();
  }

  // Fetch Mutterit products from Firestore by category filter
  Future<List<Products>> getMutterit() async {
    QuerySnapshot snapshot =
        await _firestore
            .collection('products')
            .where('category', isEqualTo: 'Mutterit')
            .get();

    return snapshot.docs.map((doc) => Products.fromFirestore(doc)).toList();
  }

  // Fetch a single product by document ID (not by custom 'id' field)
  Future<Products> getProductById(String productId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore
              .collection('products')
              .doc(productId) // Query by document ID directly
              .get();

      if (snapshot.exists) {
        return Products.fromFirestore(snapshot);
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      throw Exception("Product not found: $e");
    }
  }
}
