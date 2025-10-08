

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:tvshows/providers/search_provider.dart'; 
import 'package:tvshows/utils/enums.dart';
import 'package:tvshows/widgets/show_card.dart';
import 'package:tvshows/screens/show_details_page.dart'; 

class SearchScreen extends StatelessWidget { 
  const SearchScreen({super.key});

  
  Widget _buildContent(BuildContext context, SearchProvider provider) {
    
    switch (provider.state) {
      case UIState.initial:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_rounded, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text('Start typing to search for TV shows.', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      case UIState.loading:
        return const Center(child: CircularProgressIndicator());
      case UIState.error:
        
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text('An error occurred. Check your network.', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      
      
      case UIState.success:
        if (provider.searchResults.isEmpty) {
          return const Center(child: Text('No results found for your search.'));
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: provider.searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final show = provider.searchResults[index];
            
            
            return ShowCard(
              heroTag: 'search_show_${show.id}',
              title: show.name ?? 'No Title',
              imageUrl: show.imageUrl,
              rating: show.rating,
              onTap: () {
                
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowDetailsPage(
                      id: show.id,
                      heroTag: 'search_show_${show.id}',
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
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final searchProvider = Provider.of<SearchProvider>(context, listen: false); 
    
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          
          onSubmitted: (query) => searchProvider.searchShows(query), 
          decoration: const InputDecoration(
            hintText: 'Search shows by name...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              
              searchProvider.searchShows(''); 
            },
          ),
        ],
      ),
      
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          return _buildContent(context, provider);
        },
      ),
    );
  }
}