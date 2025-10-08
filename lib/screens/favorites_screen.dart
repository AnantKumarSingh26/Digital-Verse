

import 'package:flutter/material.dart';
import 'package:tvshows/widgets/show_card.dart';
import 'package:provider/provider.dart';
import 'package:tvshows/providers/favorites_provider.dart';
import 'package:tvshows/screens/show_details_page.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  
  final List<int> dummyFavorites = const []; 
  

  
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
            
          ],
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  
  return Consumer<FavoritesProvider>(
    builder: (context, favoritesProvider, child) {
      final favoriteShows = favoritesProvider.favorites;

      return Scaffold(
        appBar: AppBar(title: const Text('My Favorites')),
        body: favoriteShows.isEmpty
            ? _buildEmptyState() 
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