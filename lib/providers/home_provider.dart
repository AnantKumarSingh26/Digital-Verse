// lib/providers/home_provider.dart

import 'package:flutter/material.dart';
import 'package:tvshows/models/show_model.dart';
import 'package:tvshows/services/tvmaze_service.dart';
import 'package:tvshows/utils/enums.dart';

class HomeProvider with ChangeNotifier {
  final TVMazeService _tvMazeService = TVMazeService();
  
  // State variables
  List<ShowModel> _shows = [];
  FilterCategory _selectedCategory = FilterCategory.trending;
  UIState _state = UIState.initial;
  String? _errorMessage;

  // Getters (to expose data to the UI)
  List<ShowModel> get shows => _shows;
  FilterCategory get selectedCategory => _selectedCategory;
  UIState get state => _state;
  String? get errorMessage => _errorMessage;

  // Initialization: Fetch the first set of trending shows
  HomeProvider() {
    fetchShows(FilterCategory.trending);
  }

  // Action: Fetch shows based on the selected category
  Future<void> fetchShows(FilterCategory category) async {
    // 1. Check if the category has changed to avoid unnecessary API calls
    if (_selectedCategory == category && _state == UIState.success) {
      return;
    }
    
    // 2. Set loading state and update category
    _state = UIState.loading;
    _selectedCategory = category;
    _shows = [];
    notifyListeners(); // Notify UI to show loading indicator

    try {
      // 3. Call the service
      final results = await _tvMazeService.fetchShows(category);

      // 4. Update success state
      _shows = results;
      _state = UIState.success;
      _errorMessage = null;

    } catch (e) {
      // 5. Update error state
      _state = UIState.error;
      _errorMessage = e.toString().contains('Exception:') 
          ? e.toString().split('Exception: ')[1]
          : 'An unexpected error occurred.';
      _shows = []; // Clear old results on error
    } finally {
      // 6. Notify UI of final state
      notifyListeners();
    }
  }

  // TODO: Add support for paginated fetching (infinite scrolling)
}