

import 'package:flutter/material.dart';
import 'package:tvshows/models/show_model.dart';
import 'package:tvshows/services/tvmaze_service.dart';
import 'package:tvshows/utils/enums.dart';

class HomeProvider with ChangeNotifier {
  final TVMazeService _tvMazeService = TVMazeService();
  
  
  List<ShowModel> _shows = [];
  FilterCategory _selectedCategory = FilterCategory.trending;
  UIState _state = UIState.initial;
  String? _errorMessage;

  
  List<ShowModel> get shows => _shows;
  FilterCategory get selectedCategory => _selectedCategory;
  UIState get state => _state;
  String? get errorMessage => _errorMessage;

  
  HomeProvider() {
    fetchShows(FilterCategory.trending);
  }

  
  Future<void> fetchShows(FilterCategory category) async {
    
    if (_selectedCategory == category && _state == UIState.success) {
      return;
    }
    
    
    _state = UIState.loading;
    _selectedCategory = category;
    _shows = [];
    notifyListeners(); 

    try {
      
      final results = await _tvMazeService.fetchShows(category);

      
      _shows = results;
      _state = UIState.success;
      _errorMessage = null;

    } catch (e) {
      
      _state = UIState.error;
      _errorMessage = e.toString().contains('Exception:') 
          ? e.toString().split('Exception: ')[1]
          : 'An unexpected error occurred.';
      _shows = []; 
    } finally {
      
      notifyListeners();
    }
  }

  
}