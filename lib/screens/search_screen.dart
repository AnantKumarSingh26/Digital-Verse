// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:tvshows/utils/enums.dart';
import 'package:tvshows/widgets/show_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Local state to simulate the UI state managed by the SearchProvider later
  UIState _currentState = UIState.initial;
  final List<int> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  // Dummy function to simulate a search delay and state change
  void _performDummySearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _currentState = UIState.initial;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _currentState = UIState.loading;
      _searchResults.clear();
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success/error condition
    if (query.toLowerCase() == 'error') {
      setState(() {
        _currentState = UIState.error;
      });
    } else {
      // Simulate getting 5 results
      setState(() {
        _searchResults.addAll(List.generate(5, (index) => index));
        _currentState = UIState.success;
      });
    }
  }
  
  // Widget to display based on the current UI state
  Widget _buildStateWidget(UIState state) {
    switch (state) {
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
        // Placeholder for Custom Lottie animations (Bonus Addon)
        return const Center(child: CircularProgressIndicator()); 
      case UIState.error:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text('An error occurred. Please try again.', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      case UIState.success:
        if (_searchResults.isEmpty) {
          return const Center(child: Text('No results found for your search.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _searchResults.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            return ShowCard(
              heroTag: 'search_show_$index',
              title: 'Search Result ${index + 1}',
              imageUrl: 'https://via.placeholder.com/210x295.png?text=Search+R${index + 1}',
              onTap: () {
                // TODO: Navigate to ShowDetailsPage
              },
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: _performDummySearch,
          decoration: const InputDecoration(
            hintText: 'Search shows by name...',
            border: InputBorder.none,
          ),
        ),
        // Add a clear button
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performDummySearch('');
            },
          ),
        ],
      ),
      body: _buildStateWidget(_currentState),
    );
  }
}