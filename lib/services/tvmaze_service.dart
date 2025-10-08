// lib/services/tvmaze_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tvshows/models/show_model.dart';
import 'package:tvshows/utils/enums.dart';

class TVMazeService {

  static const String _baseUrl = 'https://api.tvmaze.com';
  
  
  

  
  




Future<List<ShowModel>> fetchShows(FilterCategory category) async {
  
  String pageNumber;
  switch (category) {
    case FilterCategory.trending:
      pageNumber = '0'; 
      break;
    case FilterCategory.popular:
      pageNumber = '1'; 
      break;
    case FilterCategory.upcoming:
      pageNumber = '2'; 
      break;
    default:
      pageNumber = '0';
  }

  
  final endpoint = '/shows?page=$pageNumber'; 
  final url = Uri.parse('$_baseUrl$endpoint');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      
      
      
      return jsonList.map((json) => ShowModel.fromJson(json)).toList();
      
    } else {
      throw Exception('Failed to load shows. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}



  
  
  Future<List<ShowModel>> searchShows(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse('$_baseUrl/search/shows?q=$query');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        
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

  
  
  Future<ShowModel> getShowDetails(int id) async {
    final url = Uri.parse('$_baseUrl/shows/$id');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        
        return ShowModel.fromJson(json);
      } else {
        throw Exception('Failed to load show details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}