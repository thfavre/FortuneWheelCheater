import 'package:flutter/material.dart';
import 'theme.dart'; // Import the theme file
import 'screens/main_screen.dart'; // Adjust path to your NameInputScreen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Picker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Use light theme
      darkTheme: AppTheme.darkTheme, // Use dark theme
      themeMode: ThemeMode.dark, // Set to ThemeMode.light, ThemeMode.dark, or ThemeMode.system
      home: MainScreen(),
    );
  }
}
