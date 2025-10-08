

import 'package:flutter/material.dart';
import 'package:tvshows/models/show_model.dart';
import 'package:tvshows/services/tvmaze_service.dart';
import 'package:tvshows/utils/enums.dart';

class SearchProvider with ChangeNotifier {
  final TVMazeService _tvMazeService = TVMazeService();

  
  List<ShowModel> _searchResults = [];
  UIState _state = UIState.initial;

  
  List<ShowModel> get searchResults => _searchResults;
  UIState get state => _state;

  
  Future<void> searchShows(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _state = UIState.initial;
      notifyListeners();
      return;
    }

    _state = UIState.loading;
    _searchResults = [];
    notifyListeners(); 

    try {
      final results = await _tvMazeService.searchShows(query);
      
      _searchResults = results;
      _state = UIState.success;
    } catch (e) {
      _state = UIState.error;
      _searchResults = [];
      
      print('Search Error: $e');
    } finally {
      notifyListeners();
    }
  }
}