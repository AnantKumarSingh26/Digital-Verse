// lib/services/tvmaze_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tvshows/models/show_model.dart';
import 'package:tvshows/utils/enums.dart';

class TVMazeService {
  // Use a constant for the base URL and your API key
  static const String _baseUrl = 'https://api.tvmaze.com';
  // Note: While the core search/details endpoints don't need the key, 
  // you can store it here for future user-specific endpoints (like followed shows).
  // const String _apiKey = 'TyJocdZ8pWG9eum7vEPRXV5ULgRIlRRW'; 

  // --- 1. Fetch Filtered/Trending Shows ---
  // lib/services/tvmaze_service.dart

// ... (existing imports and class definition)

// --- 1. Fetch Filtered/Trending Shows ---
Future<List<ShowModel>> fetchShows(FilterCategory category) async {
  // Use different page numbers to simulate different lists (Trending/Popular/Upcoming)
  String pageNumber;
  switch (category) {
    case FilterCategory.trending:
      pageNumber = '0'; // Page 0 for "Trending"
      break;
    case FilterCategory.popular:
      pageNumber = '1'; // Page 1 for "Popular"
      break;
    case FilterCategory.upcoming:
      pageNumber = '2'; // Page 2 for "Upcoming"
      break;
    default:
      pageNumber = '0';
  }

  // Use the standard '/shows' endpoint which reliably returns a list of shows
  final endpoint = '/shows?page=$pageNumber'; 
  final url = Uri.parse('$_baseUrl$endpoint');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      
      // Since '/shows?page=' returns a list of pure Show objects,
      // we map them directly to ShowModel.
      return jsonList.map((json) => ShowModel.fromJson(json)).toList();
      
    } else {
      throw Exception('Failed to load shows. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}

// ... (rest of the class)

  // --- 2. Search Shows by Name ---
  // Required endpoint: /search/shows?q=... 
  Future<List<ShowModel>> searchShows(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse('$_baseUrl/search/shows?q=$query');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        // The search endpoint returns objects with a nested 'show' key (e.g., {'score': 1.0, 'show': {...}})
        return jsonList
            .map((json) => ShowModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search shows. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // --- 3. Get Show Details by ID ---
  // Required endpoint: /shows/{id} 
  Future<ShowModel> getShowDetails(int id) async {
    final url = Uri.parse('$_baseUrl/shows/$id');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        // We use the ShowModel.fromJson factory again, passing the root JSON
        return ShowModel.fromJson(json);
      } else {
        throw Exception('Failed to load show details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}