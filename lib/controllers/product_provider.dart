import 'package:flutter/material.dart';
import 'package:construction_store_mobile_app/models/product_model.dart';
import 'package:construction_store_mobile_app/services/helper.dart';

class ProductNotifier extends ChangeNotifier {
  int _activepage = 0;
  List<Products> _allProducts = [];
  bool _isLoading = false;
  Future<Products>? _product; // For single product fetching

  // Getters
  int get activepage => _activepage;
  List<Products> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  Future<Products>? get product => _product;

  // Setter for active page
  set activePage(int newIndex) {
    _activepage = newIndex;
    notifyListeners();
  }

  // Fetch all products across categories
  Future<void> fetchAllProducts() async {
    if (_allProducts.isNotEmpty) return; // Skip if already fetched

    _isLoading = true;
    notifyListeners();

    try {
      final ruuvitList = await Helper().getRuuvit();
      final pultitList = await Helper().getPultit();
      final mutteritList = await Helper().getMutterit();
      _allProducts = [...ruuvitList, ...pultitList, ...mutteritList];
      print("Fetched ${_allProducts.length} products");
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Category-specific getters
  List<Products> get ruuvitList =>
      _allProducts.where((product) => product.category == "Ruuvit").toList();
  List<Products> get pultitList =>
      _allProducts.where((product) => product.category == "Pultit").toList();
  List<Products> get mutteritList =>
      _allProducts.where((product) => product.category == "Mutterit").toList();

  // Fetch a single product by ID (for the product detail page)
  Future<void> getProductById(String id) async {
    _product = Helper().getProductById(id);
    notifyListeners();
  }
}
