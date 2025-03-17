import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackageProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _packages = [];
  String? userId;

  List<Map<String, dynamic>> get packages => _packages;

  void setUserId(String userId) {
    this.userId = userId;
    // Delay getPackages() until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPackages();
    });
  }

  Future<void> getPackages() async {
    try {
      if (userId == null) {
        debugPrint('PackageProvider: User ID is not set');
        return;
      }

      QuerySnapshot packageSnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('packages')
              .get();

      _packages =
          packageSnapshot.docs.map((doc) {
            return {
              "key": doc.id,
              "name": doc['name'],
              "items": List<Map<String, dynamic>>.from(doc['items']),
            };
          }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('PackageProvider: Error fetching packages: $e');
    }
  }

  Future<void> savePackage(
    String packageName,
    List<Map<String, dynamic>> items,
  ) async {
    try {
      if (userId == null) {
        debugPrint('PackageProvider: User ID is not set');
        return;
      }

      DocumentReference newPackage = await _firestore
          .collection('users')
          .doc(userId)
          .collection('packages')
          .add({"name": packageName, "items": items});

      _packages.add({
        "key": newPackage.id,
        "name": packageName,
        "items": items,
      });

      notifyListeners();
    } catch (e) {
      debugPrint('PackageProvider: Error saving package: $e');
    }
  }

  Future<void> deletePackage(String key) async {
    try {
      if (userId == null) {
        debugPrint('PackageProvider: User ID is not set');
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('packages')
          .doc(key)
          .delete();

      _packages.removeWhere((package) => package['key'] == key);
      notifyListeners();
    } catch (e) {
      debugPrint('PackageProvider: Error deleting package: $e');
    }
  }

  Future<void> updatePackage(
    String key,
    String newName,
    List<Map<String, dynamic>> newItems,
  ) async {
    try {
      if (userId == null) {
        debugPrint('PackageProvider: User ID is not set');
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('packages')
          .doc(key)
          .update({"name": newName, "items": newItems});

      var packageIndex = _packages.indexWhere(
        (package) => package['key'] == key,
      );
      if (packageIndex != -1) {
        _packages[packageIndex] = {
          "key": key,
          "name": newName,
          "items": newItems,
        };
        notifyListeners();
      }
    } catch (e) {
      debugPrint('PackageProvider: Error updating package: $e');
    }
  }
}
