import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritesNotifier extends ChangeNotifier {
  final _favBox = Hive.box('fav_box');

  List<dynamic> _ids = [];
  List<dynamic> _favorites = [];
  List<dynamic> _fav = [];

  List<dynamic> get ids => _ids;
  List<dynamic> get favorites => _favorites;
  List<dynamic> get fav => _fav;

  set ids(List<dynamic> newIds) {
    _ids = newIds;
    notifyListeners();
  }

  set favorites(List<dynamic> newFav) {
    _favorites = newFav;
    notifyListeners();
  }

  set fav(List<dynamic> newFav) {
    _fav = newFav;
    notifyListeners();
  }

  getFavorites() {
    final favData =
        _favBox.keys.map((key) {
          final item = _favBox.get(key);

          return {"key": key, "id": item['id']};
        }).toList();

    _favorites = favData;
    _ids = _favorites.map((item) => item['id']).toList();
  }

  getAllData() {
    final favData =
        _favBox.keys.map((key) {
          final item = _favBox.get(key);

          return {
            "key": key,
            "id": item['id'],
            "name": item['name'],
            "price": item['price'],
            "image": item['image'],
            "category": item['category'],
          };
        }).toList();
    _fav = favData.reversed.toList();
  }

  Future<void> deleteFav(int key) async {
    await _favBox.delete(key);
  }

  Future<void> createFav(Map<String, dynamic> addFav) async {
    bool exists = _favBox.values.any((item) => item['id'] == addFav['id']);

    if (!exists) {
      await _favBox.add(addFav);
    }
  }
}
