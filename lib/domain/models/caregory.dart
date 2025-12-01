import 'dart:ui';

class Category {
  final String id;
  final String name;
  final String iconAsset;
  final Color color;
  final String description;

  const Category({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.color,
    required this.description,
  });
}
