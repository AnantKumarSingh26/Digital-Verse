// lib/services/hive_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tvshows/models/show_model.dart';

class HiveService {
  static const String _boxName = 'favoritesBox';

  // Get the box instance. This box should be opened in main.dart
  Box<ShowModel> get _favoritesBox => Hive.box<ShowModel>(_boxName);

  // Load all favorites
  List<ShowModel> getFavorites() {
    return _favoritesBox.values.toList();
  }

  // Save a show (using its ID as the key for easy lookup)
  Future<void> addFavorite(ShowModel show) async {
    await _favoritesBox.put(show.id, show);
  }

  // Remove a show by its ID
  Future<void> removeFavorite(int showId) async {
    await _favoritesBox.delete(showId);
  }

  // Check if a show exists in the box
  bool isFavorite(int showId) {
    return _favoritesBox.containsKey(showId);
  }
}