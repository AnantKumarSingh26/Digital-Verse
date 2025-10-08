

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:tvshows/providers/favorites_provider.dart'; 
import 'package:tvshows/models/show_model.dart'; 

class ShowDetailsPage extends StatelessWidget {
  
  final int id;
  final String heroTag;
  final String title;
  final String? imageUrl;
  final double? rating;
  final String? summary;
  final List<String>? genres;

  const ShowDetailsPage({
    super.key,
    required this.id,
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

    
    final String displaySummary =
        summary ?? 'No summary available for this show.';
    final List<String> displayGenres = genres ?? ['Unknown'];

    return Scaffold(
      
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true, 
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              background: Hero(
                tag: heroTag, 
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

                    
                    Text('Summary', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    
                    Text(
                      displaySummary.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),

      
      
      floatingActionButton: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          
          final currentShow = ShowModel(
            id: id, 
            name: title,
            imageUrl: imageUrl,
            rating: rating,
            summary: summary,
            genres: genres,
          );

          final isFav = favoritesProvider.isFavorite(currentShow.id);

          return FloatingActionButton(
            heroTag: 'fab_tag', 
            onPressed: () {
              favoritesProvider.toggleFavorite(currentShow);
            },
            
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
