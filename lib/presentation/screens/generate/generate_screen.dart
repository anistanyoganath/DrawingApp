import 'dart:typed_data';
import 'package:aidrawing/core/constants/app_styles.dart';
import 'package:aidrawing/core/constants/colors.dart';
import 'package:aidrawing/domain/models/caregory.dart';
import 'package:aidrawing/domain/models/drawing.dart';
import 'package:aidrawing/domain/models/theme.dart';
import 'package:aidrawing/presentation/screens/coloring/coloring_screen.dart';
import 'package:aidrawing/service/get_ai_strokes.dart';
import 'package:aidrawing/service/drawing_renderer.dart';
import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import 'widgets/loader.dart';
import 'widgets/theme_selector.dart';

class GenerateScreen extends StatefulWidget {
  final Category category;

  const GenerateScreen({super.key, required this.category});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  DrawingTheme? _selectedTheme;
  bool _isGenerating = false;
  double _generationProgress = 0.0;
  Uint8List? _generatedImage;
  Map<String, dynamic>? _aiDrawingData;

  // Complexity options
  int _selectedComplexity = 1; // 1: Simple, 2: Medium, 3: Complex

  final List<DrawingTheme> _themes = [
    DrawingTheme(
      id: '1',
      name: 'Friendly Character',
      categoryId: '1',
      keywords: ['friendly', 'smiling', 'cartoon'],
      description: 'A happy character with simple shapes',
    ),
    DrawingTheme(
      id: '2',
      name: 'Action Scene',
      categoryId: '1',
      keywords: ['action', 'dynamic', 'movement'],
      description: 'Character in an action pose',
    ),
    DrawingTheme(
      id: '3',
      name: 'Detailed Design',
      categoryId: '1',
      keywords: ['detailed', 'patterns', 'decorative'],
      description: 'Drawing with interesting patterns and details',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (_themes.isNotEmpty) {
      _selectedTheme = _themes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Create ${widget.category.name} Drawing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isGenerating) return;
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppStyles.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.category.color,
                      widget.category.color.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _getEmojiForCategory(widget.category.name),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.category.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Theme Selection
              ThemeSelector(
                themes: _themes,
                selectedTheme: _selectedTheme,
                onThemeSelected: (theme) {
                  setState(() {
                    _selectedTheme = theme;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Complexity Selection
              _buildComplexitySelector(),

              const SizedBox(height: 20),

              // Generated Drawing Preview
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _buildPreviewContent(),
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              if (_generatedImage != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'Generate Another',
                        onPressed: _generateDrawing,
                        icon: Icons.refresh,
                        isLoading: _isGenerating,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Start Coloring',
                        onPressed: _startColoring,
                        icon: Icons.brush,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                PrimaryButton(
                  text: _isGenerating ? 'Generating...' : 'Generate Drawing',
                  onPressed: _isGenerating ? null : _generateDrawing,
                  icon: _isGenerating ? null : Icons.auto_awesome,
                  isLoading: _isGenerating,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComplexitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drawing Complexity:',
          style: AppStyles.heading3.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildComplexityOption('Simple', 1),
            const SizedBox(width: 12),
            _buildComplexityOption('Medium', 2),
            const SizedBox(width: 12),
            _buildComplexityOption('Complex', 3),
          ],
        ),
      ],
    );
  }

  Widget _buildComplexityOption(String label, int value) {
    final isSelected = _selectedComplexity == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedComplexity = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getComplexityDescription(value),
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getComplexityDescription(int value) {
    switch (value) {
      case 1:
        return '10-20 lines\nEasy for beginners';
      case 2:
        return '20-40 lines\nPerfect for kids';
      case 3:
        return '40-60 lines\nMore details';
      default:
        return '';
    }
  }

  Widget _buildPreviewContent() {
    if (_isGenerating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Creating your drawing...',
              style: AppStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_generatedImage != null) {
      return Column(
        children: [
          // Drawing Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _aiDrawingData?['title'] ?? 'Your Drawing',
              style: AppStyles.heading3.copyWith(color: AppColors.primary),
            ),
          ),

          // Drawing Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.memory(_generatedImage!, fit: BoxFit.contain),
            ),
          ),

          // Drawing Info
          if (_aiDrawingData != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_aiDrawingData?['description'] != null)
                    Text(
                      _aiDrawingData!['description'],
                      style: AppStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  if (_aiDrawingData?['hints'] != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Color Suggestions:',
                      style: AppStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: List<Widget>.from(
                        (_aiDrawingData!['hints'] as List).map((hint) {
                          return Chip(
                            label: Text(
                              hint.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: AppColors.accent.withOpacity(0.1),
                          );
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome,
          size: 64,
          color: AppColors.primary.withOpacity(0.3),
        ),
        const SizedBox(height: 16),
        Text(
          'Drawing Preview',
          style: AppStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Text(
          'AI will generate a unique ${_selectedTheme?.name.toLowerCase() ?? widget.category.name.toLowerCase()} drawing here',
          style: AppStyles.bodySmall.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _generateDrawing() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _generatedImage = null;
      _aiDrawingData = null;
    });

    try {
      // Show loading dialog
      _showGenerationDialog();

      // Generate AI drawing
      final aiData = await AiService.generateDrawing(
        theme: widget.category.name,
        subTheme: _selectedTheme?.name,
        style: _selectedTheme?.keywords.join(', '),
        complexity: _selectedComplexity,
      );

      // Render the drawing to an image
      final imageData = await DrawingRenderer.renderDrawing(aiData);

      // Update state
      setState(() {
        _aiDrawingData = aiData;
        _generatedImage = imageData;
      });

      // Close dialog
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating drawing: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _showGenerationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AIThinkingLoader(
          theme: _selectedTheme?.name ?? widget.category.name,
          progress: _generationProgress,
        ),
      ),
    );
  }

  void _startColoring() {
    if (_generatedImage == null || _aiDrawingData == null) return;

    // Create drawing object
    final drawing = Drawing(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _aiDrawingData!['title'] ?? 'AI Drawing',
      category: widget.category.name,
      description: _aiDrawingData!['description'],
      outlineData: _generatedImage,
      createdAt: DateTime.now(),
      completionPercentage: 0.0,
      aiData: _aiDrawingData,
      colorHints: List<String>.from(_aiDrawingData!['hints'] ?? []),
    );

    // Navigate to coloring screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ColoringScreen(drawing: drawing)),
    );
  }

  String _getEmojiForCategory(String categoryName) {
    switch (categoryName) {
      case 'Dinosaurs':
        return '🦖';
      case 'Space':
        return '🚀';
      case 'Unicorns':
        return '🦄';
      default:
        return '🎨';
    }
  }
}
