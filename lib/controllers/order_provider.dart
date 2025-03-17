import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];
  String? userId;
  bool _isLoading = false;

  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;

  void setUserId(String userId) {
    this.userId = userId;
    debugPrint('OrderProvider: Setting userId to $userId');
    getOrders(); // Fetch orders when userId is set
  }

  Future<void> getOrders() async {
    if (userId == null) {
      debugPrint('OrderProvider: User ID is not set');
      return;
    }

    _isLoading = true;
    notifyListeners(); // Notify that loading has started

    try {
      QuerySnapshot orderSnapshot =
          await FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      _orders =
          orderSnapshot.docs.map((doc) {
            return {
              "id": doc.id,
              "amount": doc['amount'],
              "status": doc['status'],
              "createdAt": doc['createdAt'],
              "items": doc['items'],
            };
          }).toList();

      debugPrint('OrderProvider: Fetched ${_orders.length} orders');
    } catch (e) {
      debugPrint('OrderProvider: Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify that loading is complete
    }
  }
}
