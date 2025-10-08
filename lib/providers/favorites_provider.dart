// lib/providers/favorites_provider.dart

import 'package:flutter/material.dart';
import 'package:tvshows/models/show_model.dart';
import 'package:tvshows/services/hive_service.dart';

class FavoritesProvider with ChangeNotifier {
  // Use the new service
  final HiveService _hiveService = HiveService(); 
  
  List<ShowModel> _favorites = [];

  List<ShowModel> get favorites => _favorites;

  // Constructor: Load favorites immediately
  FavoritesProvider() {
    _loadFavorites();
  }

  // Load data from Hive
  void _loadFavorites() {
    _favorites = _hiveService.getFavorites();
    notifyListeners();
  }

  bool isFavorite(int showId) {
    // Check local list for faster UI updates
    return _favorites.any((show) => show.id == showId); 
  }
  
  // Main action to toggle status
  void toggleFavorite(ShowModel show) {
    if (isFavorite(show.id)) {
      _hiveService.removeFavorite(show.id);
      _favorites.removeWhere((s) => s.id == show.id);
    } else {
      _hiveService.addFavorite(show);
      _favorites.add(show);
    }
    notifyListeners();
  }
}