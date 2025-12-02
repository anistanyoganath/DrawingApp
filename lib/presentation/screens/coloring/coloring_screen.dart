import 'package:aidrawing/core/constants/app_strings.dart';
import 'package:aidrawing/core/constants/app_styles.dart';
import 'package:aidrawing/core/constants/colors.dart';
import 'package:aidrawing/presentation/screens/coloring/widgets/color_palate.dart';
import 'package:aidrawing/presentation/screens/coloring/widgets/tool_bar.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/drawing.dart';
import '../../widgets/primary_button.dart';
import 'widgets/canvas_area.dart';

class ColoringScreen extends StatefulWidget {
  final Drawing? drawing;

  const ColoringScreen({super.key, this.drawing});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  Color _selectedColor = AppColors.rainbowColors[0];
  double _brushSize = 10.0;
  bool _isErasing = false;
  final GlobalKey<CanvasAreaState> _canvasKey = GlobalKey();

  // Sample drawing
  final Drawing _currentDrawing = Drawing(
    id: '1',
    title: 'Friendly T-Rex',
    category: 'Dinosaurs',
    createdAt: DateTime.now(),
    completionPercentage: 0.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_currentDrawing.title),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _currentDrawing.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _currentDrawing.isFavorite ? AppColors.error : null,
            ),
            onPressed: _toggleFavorite,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                _shareDrawing();
              } else if (value == 'save_gallery') {
                _saveToGallery();
              } else if (value == 'print') {
                _printDrawing();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'save_gallery',
                child: Row(
                  children: [
                    Icon(Icons.save_alt, size: 20),
                    SizedBox(width: 8),
                    Text('Save to Gallery'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(Icons.print, size: 20),
                    SizedBox(width: 8),
                    Text('Print'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppStyles.screenPadding,
          child: Column(
            children: [
              // Progress Indicator
              _buildProgressIndicator(),

              const SizedBox(height: 16),

              // Main Content
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Color Palette
                    SizedBox(
                      width: 80,
                      child: ColorPalette(
                        selectedColor: _selectedColor,
                        onColorSelected: (color) {
                          setState(() {
                            _selectedColor = color;
                            _isErasing = false;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Drawing Area
                    Expanded(
                      child: CanvasArea(
                        key: _canvasKey,
                        currentColor: _selectedColor,
                        brushSize: _brushSize,
                        isErasing: _isErasing,
                        outlineImage: widget.drawing?.outlineData,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Toolbar
              ToolBar(
                brushColor: _selectedColor,
                brushSize: _brushSize,
                isErasing: _isErasing,
                onBrushSizeChanged: (size) {
                  setState(() {
                    _brushSize = size;
                  });
                },
                onErase: () {
                  setState(() {
                    _isErasing = !_isErasing;
                  });
                },
                onUndo: () {
                  _canvasKey.currentState?.undo();
                  setState(() {});
                },
                onRedo: () {
                  _canvasKey.currentState?.redo();
                  setState(() {});
                },
                onClear: () {
                  _showClearConfirmation(context);
                },
                onSave: _saveDrawing,
                canUndo: _canvasKey.currentState?.canUndo ?? false,
                canRedo: _canvasKey.currentState?.canRedo ?? false,
              ),

              const SizedBox(height: 16),

              // Save Button
              PrimaryButton(
                text: AppStrings.saveDrawing,
                onPressed: _saveDrawing,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${(_currentDrawing.completionPercentage * 100).toInt()}%',
              style: AppStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _currentDrawing.completionPercentage,
          backgroundColor: Colors.grey.shade200,
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() {
      // Update drawing favorite status
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentDrawing.isFavorite
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareDrawing() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing drawing...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _saveToGallery() {
    // Implement save to gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to gallery!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _printDrawing() {
    // Implement print functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printing...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _saveDrawing() {
    // Implement save drawing logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Drawing saved!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Do you want to save before exiting?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveDrawing();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Save & Exit'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Drawing'),
        content: const Text(
          'Are you sure you want to clear the entire drawing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _canvasKey.currentState?.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
