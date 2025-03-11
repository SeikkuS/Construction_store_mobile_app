import 'package:flutter/services.dart' as the_bundle;
import 'package:shope_collection_app/models/product_model.dart';

class Helper {
  //  Ruuvi List
  Future<List<Products>> getRuuvit() async {
    final data = await the_bundle.rootBundle.loadString(
      "assets/models/ruuvit.json",
    );
    final ruuviList = productsFromJson(data);

    return ruuviList;
  }

  //  Pultti list
  Future<List<Products>> getPultit() async {
    final data = await the_bundle.rootBundle.loadString(
      "assets/models/pultit.json",
    );
    final pulttiList = productsFromJson(data);

    return pulttiList;
  }

  //  Mutteri list
  Future<List<Products>> getMutterit() async {
    final data = await the_bundle.rootBundle.loadString(
      "assets/models/mutterit.json",
    );
    final mutteriList = productsFromJson(data);

    return mutteriList;
  }

  // Single mutteri
  Future<Products> getMutteritById(String id) async {
    final data = await the_bundle.rootBundle.loadString(
      "assets/models/mutterit.json",
    );
    final mutteriList = productsFromJson(data);

    final product = mutteriList.firstWhere((product) => product.id == id);

    return product;
  }

  // Single pultti
  Future<Products> getPultitById(String id) async {
    final data = await the_bundle.rootBundle.loadString(
      "assets/models/pultit.json",
    );
    final pulttiList = productsFromJson(data);

    final product = pulttiList.firstWhere((product) => product.id == id);

    return product;
  }

  // Single ruuvi
  Future<Products> getRuuvitById(String id) async {
    final data = await the_bundle.rootBundle.loadString(
      "assets/models/ruuvit.json",
    );
    final ruuviList = productsFromJson(data);

    final product = ruuviList.firstWhere((product) => product.id == id);

    return product;
  }
}
