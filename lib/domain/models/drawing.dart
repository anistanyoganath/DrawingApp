import 'dart:typed_data';

class Drawing {
  final String id;
  final String title;
  final String category;
  final String? description;
  final Uint8List? outlineData;
  final Uint8List? coloredData;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;
  final double completionPercentage;
  final Map<String, dynamic>? aiData; // Store AI-generated stroke data
  final List<String>? colorHints;

  Drawing({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.outlineData,
    this.coloredData,
    required this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    this.completionPercentage = 0.0,
    this.aiData,
    this.colorHints,
  });

  // Create a copy with updated fields
  Drawing copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    Uint8List? outlineData,
    Uint8List? coloredData,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    double? completionPercentage,
    Map<String, dynamic>? aiData,
    List<String>? colorHints,
  }) {
    return Drawing(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      outlineData: outlineData ?? this.outlineData,
      coloredData: coloredData ?? this.coloredData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      aiData: aiData ?? this.aiData,
      colorHints: colorHints ?? this.colorHints,
    );
  }
}
