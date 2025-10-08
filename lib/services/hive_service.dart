

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tvshows/models/show_model.dart';

class HiveService {
  static const String _boxName = 'favoritesBox';

  
  Box<ShowModel> get _favoritesBox => Hive.box<ShowModel>(_boxName);

  
  List<ShowModel> getFavorites() {
    return _favoritesBox.values.toList();
  }

  
  Future<void> addFavorite(ShowModel show) async {
    await _favoritesBox.put(show.id, show);
  }

  
  Future<void> removeFavorite(int showId) async {
    await _favoritesBox.delete(showId);
  }

  
  bool isFavorite(int showId) {
    return _favoritesBox.containsKey(showId);
  }
}