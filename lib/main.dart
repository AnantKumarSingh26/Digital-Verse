// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Screens
import 'package:tvshows/screens/home_screen.dart';

// Models (Needed for Hive TypeAdapter)
import 'package:tvshows/models/show_model.dart'; 

// Providers (State Managers)
import 'package:tvshows/providers/home_provider.dart';
import 'package:tvshows/providers/favorites_provider.dart';
import 'package:tvshows/providers/search_provider.dart';
import 'package:tvshows/providers/theme_provider.dart'; 


void main() async {
  // 1. Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Hive for local storage (required for offline favorites)
  await Hive.initFlutter();

  // 3. Register the TypeAdapter for the ShowModel.
  //    NOTE: You must generate the 'show_model.g.dart' file and uncomment this line 
  //    once you implement the Hive TypeAdapter in show_model.dart.
  Hive.registerAdapter(ShowModelAdapter()); 

  // 4. Open the 'favorites' box where favorite ShowModel objects will be stored.
  //    NOTE: This must be done BEFORE the FavoritesProvider is initialized.
  await Hive.openBox<ShowModel>('favoritesBox'); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Setup MultiProvider
    //    We register all state managers (Providers) at the root of the app.
    return MultiProvider(
      providers: [
        // Manages API calls for the Home Screen and filter logic
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        // Manages API calls for the Search Screen and UIState
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        // Manages local storage (Hive) for favorite shows
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        // Manages the dark mode toggle (Bonus Addon)
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      
      // 6. Consumer to listen to ThemeProvider (for dark mode toggle)
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Smollan Movie Verse',
            debugShowCheckedModeBanner: false,

            // Apply Theme Data managed by the ThemeProvider
            themeMode: themeProvider.themeMode,
            
            // Standard Light Theme
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.deepPurple,
              appBarTheme: const AppBarTheme(elevation: 1),
            ),
            
            // Standard Dark Theme
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.deepPurple,
            ),
            
            // 8. Initial Screen
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}