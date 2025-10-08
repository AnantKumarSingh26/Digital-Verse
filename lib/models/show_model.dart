// lib/models/show_model.dart

import 'package:hive_flutter/hive_flutter.dart';

// 1. Tell Dart to generate the adapter file
part 'show_model.g.dart'; 

// 2. Add @HiveType with a unique typeId (0 is usually the first model)
@HiveType(typeId: 0) 
class ShowModel {
  // 3. Mark all fields with @HiveField and a unique index
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? summary;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final double? rating;
  @HiveField(5)
  final List<String>? genres;

  ShowModel({
    required this.id,
    this.name,
    this.summary,
    this.imageUrl,
    this.rating,
    this.genres,
  });

  // ... (Keep the existing factory ShowModel.fromJson and toJson methods) ...
  factory ShowModel.fromJson(Map<String, dynamic> json) {
    // ... (Your existing fromJson logic) ...
    final showData = json['show'] ?? json;
    
    String? getImageUrl(Map<String, dynamic> data) {
      final image = data['image'];
      // Ensure we only store 'original' as 'medium' is often too small
      return image != null ? (image['original'] ?? image['medium']) : null; 
    }

    double? getRating(Map<String, dynamic> data) {
      final ratingMap = data['rating'];
      final average = ratingMap?['average'];
      return average != null ? (average as num).toDouble() : null;
    }

    return ShowModel(
      id: showData['id'] as int,
      name: showData['name'] as String?,
      summary: showData['summary'] as String?,
      imageUrl: getImageUrl(showData),
      rating: getRating(showData),
      genres: (showData['genres'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}