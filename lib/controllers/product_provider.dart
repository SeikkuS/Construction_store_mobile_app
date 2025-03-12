import 'package:flutter/material.dart';
import 'package:construction_store_mobile_app/models/product_model.dart';
import 'package:construction_store_mobile_app/services/helper.dart';

class ProductNotifier extends ChangeNotifier {
  int _activepage = 0;

  List<dynamic> _productSizes = [];
  List<String> _sizes = [];

  int get activepage => _activepage;

  set activePage(int newIndex) {
    _activepage = newIndex;
    notifyListeners();
  }

  List<dynamic> get productSizes => _productSizes;

  set productSizes(List<dynamic> newSizes) {
    _productSizes = newSizes;
    notifyListeners();
  }

  void toggleCheck(int index) {
    for (int i = 0; i < _productSizes.length; i++) {
      if (i == index) {
        _productSizes[i]['isSelected'] = !_productSizes[i]['isSelected'];
      }
    }
    notifyListeners();
  }

  List<String> get sizes => _sizes;

  set sizes(List<String> newSizes) {
    _sizes = newSizes;
    notifyListeners();
  }

  late Future<List<Products>> ruuvit;
  late Future<List<Products>> pultit;
  late Future<List<Products>> mutterit;
  late Future<Products> product;

  // Fetch products by category (for browsing)
  void getRuuvit() {
    ruuvit = Helper().getRuuvit();
  }

  void getPultit() {
    pultit = Helper().getPultit();
  }

  void getMutterit() {
    mutterit = Helper().getMutterit();
  }

  // Fetch a single product by ID (for the product detail page)
  void getProductById(String id) {
    product = Helper().getProductById(id);
  }

  void toggleSizeSelection(int index) {
    var selectedSize = _productSizes[index];

    // Toggle the isSelected state
    selectedSize['isSelected'] = !selectedSize['isSelected'];

    // If the size is selected, add it to the _sizes list, otherwise remove it.
    if (selectedSize['isSelected']) {
      _sizes.add(selectedSize['size']);
    } else {
      _sizes.remove(selectedSize['size']);
    }

    notifyListeners();
  }
}
