import 'package:aidrawing/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ToolBar extends StatelessWidget {
  final Color brushColor;
  final double brushSize;
  final bool isErasing;
  final ValueChanged<double> onBrushSizeChanged;
  final VoidCallback onErase;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onClear;
  final VoidCallback onSave;
  final bool canUndo;
  final bool canRedo;

  const ToolBar({
    super.key,
    required this.brushColor,
    required this.brushSize,
    required this.isErasing,
    required this.onBrushSizeChanged,
    required this.onErase,
    required this.onUndo,
    required this.onRedo,
    required this.onClear,
    required this.onSave,
    this.canUndo = false,
    this.canRedo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Brush Size
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brushColor,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    '${brushSize.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 100,
                child: Slider(
                  value: brushSize,
                  min: 1,
                  max: 30,
                  onChanged: onBrushSizeChanged,
                  activeColor: brushColor,
                  inactiveColor: Colors.grey.shade200,
                ),
              ),
            ],
          ),

          // Tools
          _buildToolButton(
            icon: Icons.brush,
            label: 'Brush',
            isActive: !isErasing,
            onTap: () => onBrushSizeChanged(brushSize), // Switch back to brush
          ),

          _buildToolButton(
            icon: Icons.cleaning_services,
            label: 'Eraser',
            isActive: isErasing,
            onTap: onErase,
          ),

          // Actions
          _buildActionButton(
            icon: Icons.undo,
            onTap: canUndo ? onUndo : null,
            isDisabled: !canUndo,
          ),

          _buildActionButton(
            icon: Icons.redo,
            onTap: canRedo ? onRedo : null,
            isDisabled: !canRedo,
          ),

          _buildActionButton(
            icon: Icons.delete,
            onTap: onClear,
            color: AppColors.error,
          ),

          _buildActionButton(
            icon: Icons.save,
            onTap: onSave,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.transparent,
            ),
          ),
          child: IconButton(
            icon: Icon(icon, size: 20),
            color: isActive ? Colors.white : Colors.grey,
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? AppColors.primary : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color? color,
    bool isDisabled = false,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: isDisabled ? Colors.grey : (color ?? AppColors.textPrimary),
      onPressed: isDisabled ? null : onTap,
      iconSize: 24,
    );
  }
}
