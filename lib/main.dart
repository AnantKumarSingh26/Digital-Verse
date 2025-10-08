
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'package:tvshows/screens/home_screen.dart';


import 'package:tvshows/models/show_model.dart'; 


import 'package:tvshows/providers/home_provider.dart';
import 'package:tvshows/providers/favorites_provider.dart';
import 'package:tvshows/providers/search_provider.dart';
import 'package:tvshows/providers/theme_provider.dart'; 


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await Hive.initFlutter();

  
  
  
  Hive.registerAdapter(ShowModelAdapter()); 

  
  
  await Hive.openBox<ShowModel>('favoritesBox'); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      
      
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Smollan Movie Verse',
            debugShowCheckedModeBanner: false,

            
            themeMode: themeProvider.themeMode,
            
            
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.deepPurple,
              appBarTheme: const AppBarTheme(elevation: 1),
            ),
            
            
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.deepPurple,
            ),
            
            
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}