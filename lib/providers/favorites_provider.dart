

import 'package:flutter/material.dart';
import 'package:tvshows/models/show_model.dart';
import 'package:tvshows/services/hive_service.dart';

class FavoritesProvider with ChangeNotifier {
  
  final HiveService _hiveService = HiveService(); 
  
  List<ShowModel> _favorites = [];

  List<ShowModel> get favorites => _favorites;

  
  FavoritesProvider() {
    _loadFavorites();
  }

  
  void _loadFavorites() {
    _favorites = _hiveService.getFavorites();
    notifyListeners();
  }

  bool isFavorite(int showId) {
    
    return _favorites.any((show) => show.id == showId); 
  }
  
  
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