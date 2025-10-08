// lib/screens/show_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // New Import
import 'package:tvshows/providers/favorites_provider.dart'; // New Import
import 'package:tvshows/models/show_model.dart'; //

class ShowDetailsPage extends StatelessWidget {
  // Requires the unique tag and data needed for display
  final String heroTag;
  final String title;
  final String? imageUrl;
  final double? rating;
  final String? summary;
  final List<String>? genres;

  const ShowDetailsPage({
    super.key,
    required this.heroTag,
    required this.title,
    this.imageUrl,
    this.rating,
    this.summary,
    this.genres,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default values for placeholders
    final String displaySummary =
        summary ?? 'No summary available for this show.';
    final List<String> displayGenres = genres ?? ['Unknown'];

    return Scaffold(
      // We use a CustomScrollView to allow the app bar and content to scroll together
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true, // App bar remains visible at the top
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // --- Hero Animation Destination ---
              background: Hero(
                tag: heroTag, // MUST match the tag from the ShowCard
                child: imageUrl != null
                    ? Image.network(imageUrl!, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, size: 80),
                      ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Rating ---
                    if (rating != null && rating! > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '${rating!.toStringAsFixed(1)} / 10',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    const Divider(height: 32),

                    // --- Genres ---
                    Text('Genres', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: displayGenres
                          .map((genre) => Chip(label: Text(genre)))
                          .toList(),
                    ),
                    const Divider(height: 32),

                    // --- Summary ---
                    Text('Summary', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    // Remove HTML tags often present in TVMaze summary
                    Text(
                      displaySummary.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      // --- Save/Remove Favorite Button ---
      // --- Find the FloatingActionButton in ShowDetailsPage ---
      floatingActionButton: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          // Create the model object needed by the provider
          final currentShow = ShowModel(
            id: id, // Assuming you passed ID to constructor
            name: title,
            imageUrl: imageUrl,
            rating: rating,
            summary: summary,
            genres: genres,
          );

          final isFav = favoritesProvider.isFavorite(currentShow.id);

          return FloatingActionButton(
            heroTag: 'fab_tag', // Needs a unique tag if using multiple FABs
            onPressed: () {
              favoritesProvider.toggleFavorite(currentShow);
            },
            // Icon changes based on status
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
          );
        },
      ),
    );
  }
}
