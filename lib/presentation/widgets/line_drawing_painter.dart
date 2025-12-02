import 'package:flutter/material.dart';

class LineDrawingPainter extends CustomPainter {
  final List<Map<String, dynamic>> lines;

  LineDrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var l in lines) {
      canvas.drawLine(
        Offset((l['x1'] as num).toDouble(), (l['y1'] as num).toDouble()),
        Offset((l['x2'] as num).toDouble(), (l['y2'] as num).toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
