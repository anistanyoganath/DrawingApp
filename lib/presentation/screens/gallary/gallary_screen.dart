import 'package:aidrawing/core/constants/app_styles.dart';
import 'package:aidrawing/core/constants/colors.dart';
import 'package:aidrawing/domain/models/drawing.dart';
import 'package:aidrawing/presentation/screens/coloring/coloring_screen.dart';
import 'package:aidrawing/presentation/screens/gallary/widgets/gallary_item.dart';
import 'package:aidrawing/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Drawing> _drawings = [
    Drawing(
      id: '1',
      title: 'Friendly T-Rex',
      category: 'Dinosaurs',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      completionPercentage: 1.0,
      isFavorite: true,
    ),
    Drawing(
      id: '2',
      title: 'Space Rocket',
      category: 'Space',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      completionPercentage: 0.7,
    ),
    Drawing(
      id: '3',
      title: 'Magical Unicorn',
      category: 'Unicorns',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      completionPercentage: 0.5,
    ),
    Drawing(
      id: '4',
      title: 'Ocean Whale',
      category: 'Ocean',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      completionPercentage: 0.3,
    ),
  ];

  String _filter = 'all'; // 'all', 'completed', 'in_progress', 'favorites'
  String _sortBy = 'recent'; // 'recent', 'oldest', 'name'

  @override
  Widget build(BuildContext context) {
    final filteredDrawings = _getFilteredDrawings();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Gallery'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortDialog),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppStyles.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats
              _buildStatsBar(),

              const SizedBox(height: 20),

              // Gallery Grid
              if (filteredDrawings.isEmpty)
                Expanded(
                  child: EmptyState(
                    title: 'No Drawings Yet',
                    description:
                        'Start creating your first drawing and it will appear here!',
                    buttonText: 'Create Drawing',
                    onButtonPressed: () {
                      Navigator.pop(context); // Go back to home
                    },
                    icon: '🖼️',
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: filteredDrawings.length,
                    itemBuilder: (context, index) {
                      final drawing = filteredDrawings[index];
                      return GalleryItem(
                        drawing: drawing,
                        onTap: () {
                          _openDrawing(drawing);
                        },
                        onFavorite: () {
                          _toggleFavorite(drawing);
                        },
                        onDelete: () {
                          _deleteDrawing(drawing);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    final total = _drawings.length;
    final completed = _drawings
        .where((d) => d.completionPercentage == 1.0)
        .length;
    final favorites = _drawings.where((d) => d.isFavorite).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(total.toString(), 'Total', AppColors.primary),
          _buildStatItem(completed.toString(), 'Completed', AppColors.success),
          _buildStatItem(favorites.toString(), 'Favorites', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  List<Drawing> _getFilteredDrawings() {
    List<Drawing> filtered = List.from(_drawings);

    // Apply filter
    switch (_filter) {
      case 'completed':
        filtered = filtered
            .where((d) => d.completionPercentage == 1.0)
            .toList();
        break;
      case 'in_progress':
        filtered = filtered.where((d) => d.completionPercentage < 1.0).toList();
        break;
      case 'favorites':
        filtered = filtered.where((d) => d.isFavorite).toList();
        break;
    }

    // Apply sort
    switch (_sortBy) {
      case 'recent':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'name':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return filtered;
  }

  void _openDrawing(Drawing drawing) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ColoringScreen(drawing: drawing)),
    );
  }

  void _toggleFavorite(Drawing drawing) {
    setState(() {
      final index = _drawings.indexWhere((d) => d.id == drawing.id);
      if (index != -1) {
        _drawings[index] = Drawing(
          id: drawing.id,
          title: drawing.title,
          category: drawing.category,
          createdAt: drawing.createdAt,
          completionPercentage: drawing.completionPercentage,
          isFavorite: !drawing.isFavorite,
        );
      }
    });
  }

  void _deleteDrawing(Drawing drawing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Drawing'),
        content: const Text(
          'Are you sure you want to delete this drawing? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _drawings.removeWhere((d) => d.id == drawing.id);
              });
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Drawing deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Drawings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All Drawings', 'all'),
            _buildFilterOption('Completed', 'completed'),
            _buildFilterOption('In Progress', 'in_progress'),
            _buildFilterOption('Favorites', 'favorites'),
          ],
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Drawings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('Most Recent', 'recent'),
            _buildSortOption('Oldest First', 'oldest'),
            _buildSortOption('Name (A-Z)', 'name'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _filter,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _filter = value;
          });
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildSortOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _sortBy,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _sortBy = value;
          });
          Navigator.pop(context);
        }
      },
    );
  }
}
