import 'dart:typed_data';
import 'package:flutter/material.dart';

class CanvasArea extends StatefulWidget {
  final Color currentColor;
  final double brushSize;
  final bool isErasing;
  final Uint8List? outlineImage;

  const CanvasArea({
    super.key,
    required this.currentColor,
    required this.brushSize,
    required this.isErasing,
    this.outlineImage,
  });

  @override
  State<CanvasArea> createState() => CanvasAreaState();
}

class CanvasAreaState extends State<CanvasArea> {
  List<DrawingPoint> points = [];
  List<List<DrawingPoint>> history = [];
  int historyIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Grid
            _buildGridBackground(),

            // Outline Image
            if (widget.outlineImage != null)
              Positioned.fill(
                child: Image.memory(widget.outlineImage!, fit: BoxFit.contain),
              ),

            // Drawing Canvas
            GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: DrawingPainter(
                  points: points,
                  isErasing: widget.isErasing,
                  eraserSize: widget.brushSize,
                ),
                size: Size.infinite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backgrounds/pattern.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.1,
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      // Clear redo history when starting new drawing
      if (historyIndex < history.length - 1) {
        history = history.sublist(0, historyIndex + 1);
      }

      points.add(
        DrawingPoint(
          offset: details.localPosition,
          color: widget.isErasing ? Colors.white : widget.currentColor,
          size: widget.brushSize,
          isErasing: widget.isErasing,
        ),
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      points.add(
        DrawingPoint(
          offset: details.localPosition,
          color: widget.isErasing ? Colors.white : widget.currentColor,
          size: widget.brushSize,
          isErasing: widget.isErasing,
        ),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      // Save to history
      history.add(List.from(points));
      historyIndex++;
    });
  }

  void undo() {
    if (historyIndex > 0) {
      setState(() {
        historyIndex--;
        points = List.from(history[historyIndex]);
      });
    }
  }

  void redo() {
    if (historyIndex < history.length - 1) {
      setState(() {
        historyIndex++;
        points = List.from(history[historyIndex]);
      });
    }
  }

  void clear() {
    setState(() {
      points.clear();
      history.clear();
      historyIndex = -1;
    });
  }

  bool get canUndo => historyIndex > 0;
  bool get canRedo => historyIndex < history.length - 1;
}

class DrawingPoint {
  final Offset offset;
  final Color color;
  final double size;
  final bool isErasing;

  DrawingPoint({
    required this.offset,
    required this.color,
    required this.size,
    required this.isErasing,
  });
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;
  final bool isErasing;
  final double eraserSize;

  DrawingPainter({
    required this.points,
    required this.isErasing,
    required this.eraserSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];

      final paint = Paint()
        ..color = currentPoint.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = currentPoint.size;

      if (currentPoint.isErasing) {
        paint.blendMode = BlendMode.clear;
      }

      canvas.drawLine(currentPoint.offset, nextPoint.offset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
