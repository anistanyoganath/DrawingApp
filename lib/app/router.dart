import 'package:aidrawing/domain/models/caregory.dart';
import 'package:aidrawing/presentation/screens/coloring/coloring_screen.dart';
import 'package:aidrawing/presentation/screens/gallary/gallary_screen.dart';
import 'package:aidrawing/presentation/screens/generate/generate_screen.dart';
import 'package:aidrawing/presentation/screens/home/home_screen.dart';
import 'package:aidrawing/presentation/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/generate':
        final category = settings.arguments as Category;
        return MaterialPageRoute(
          builder: (_) => GenerateScreen(category: category),
        );
      case '/coloring':
        return MaterialPageRoute(builder: (_) => const ColoringScreen());
      case '/gallery':
        return MaterialPageRoute(builder: (_) => const GalleryScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
