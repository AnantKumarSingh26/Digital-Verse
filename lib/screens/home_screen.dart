

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tvshows/providers/home_provider.dart';
import 'package:tvshows/providers/theme_provider.dart'; 
import 'package:tvshows/utils/enums.dart'; 
import 'package:tvshows/screens/show_details_page.dart';
import 'package:tvshows/widgets/show_card.dart';
import 'package:tvshows/widgets/filter_chips.dart';
import 'package:tvshows/screens/search_screen.dart';
import 'package:tvshows/screens/favorites_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  
  Widget _buildStateWidget(UIState state, List<dynamic> items, String? error) {
    if (state == UIState.loading || state == UIState.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state == UIState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Error: ${error ?? 'Failed to load data.'}\nPlease check your network connection.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    if (items.isEmpty && state == UIState.success) {
      return const Center(child: Text('No shows found for this category.'));
    }
    
    
    return const SizedBox.shrink(); 
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final crossAxisCount = isTablet ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smollan Movie Verse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
               Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              Provider.of<ThemeProvider>(context,listen:false).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: FilterChips(), 
          ),
          
          
          Expanded(
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                
                final stateWidget = _buildStateWidget(
                  provider.state, 
                  provider.shows, 
                  provider.errorMessage
                );

                if (provider.state != UIState.success || provider.shows.isEmpty) {
                  return stateWidget;
                }
                
                
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: provider.shows.length, 
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: isTablet ? 0.7 : 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final show = provider.shows[index];

                    return ShowCard(
                      heroTag: 'show_${show.id}', 
                      title: show.name ?? 'No Title',
                      imageUrl: show.imageUrl,
                      rating: show.rating,
                      onTap: () {
                        
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShowDetailsPage(
                              id:show.id,
                              heroTag: 'show_${show.id}',
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}