// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:tvshows/widgets/show_card.dart';
import 'package:provider/provider.dart';
import 'package:tvshows/providers/favorites_provider.dart';
import 'package:tvshows/screens/show_details_page.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  // Dummy list of favorite IDs (will be replaced by Hive data from Provider)
  final List<int> dummyFavorites = const []; // Currently empty for testing empty state
  // final List<int> dummyFavorites = const [1, 2, 3]; // Uncomment to test data view

  // Widget to show when the list is empty
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on a show\'s detail page to save it here for offline viewing.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            // Placeholder for Custom Lottie animation for empty states (Bonus Addon)
          ],
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  // Listen to the FavoritesProvider
  return Consumer<FavoritesProvider>(
    builder: (context, favoritesProvider, child) {
      final favoriteShows = favoritesProvider.favorites;

      return Scaffold(
        appBar: AppBar(title: const Text('My Favorites')),
        body: favoriteShows.isEmpty
            ? _buildEmptyState() // Your existing empty state widget
            : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: favoriteShows.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final show = favoriteShows[index];
                  return ShowCard(
                    heroTag: 'fav_show_${show.id}',
                    title: show.name ?? 'No Title',
                    imageUrl: show.imageUrl,
                    rating: show.rating,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShowDetailsPage(
                            id:show.id,
                            heroTag: 'fav_show_${show.id}',
                            title: show.name ?? 'No Title',
                            imageUrl: show.imageUrl,
                            rating: show.rating,
                            summary: show.summary,
                            genres: show.genres,
                            // Ensure you pass all required details
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      );
    },
  );
}
}