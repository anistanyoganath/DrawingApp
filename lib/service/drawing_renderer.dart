import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

class DrawingRenderer {
  static Future<Uint8List> renderDrawing(
    Map<String, dynamic> aiData, {
    double width = 300,
    double height = 300,
    Color lineColor = Colors.black,
    Color backgroundColor = Colors.white,
  }) async {
    try {
      final strokes = List<Map<String, dynamic>>.from(aiData['strokes'] ?? []);

      // Create a picture recorder
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Fill background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, width, height),
        Paint()..color = backgroundColor,
      );

      // Draw each stroke
      for (final stroke in strokes) {
        final x1 = (stroke['x1'] as num).toDouble();
        final y1 = (stroke['y1'] as num).toDouble();
        final x2 = (stroke['x2'] as num).toDouble();
        final y2 = (stroke['y2'] as num).toDouble();
        final thickness = (stroke['thickness'] as num? ?? 2.0).toDouble();

        paint.strokeWidth = thickness;

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }

      // Create image
      final picture = recorder.endRecording();
      final image = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception("Failed to convert image to byte data");
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      print("Error rendering drawing: $e");
      // Return empty image
      return await _createEmptyImage(width.toInt(), height.toInt());
    }
  }

  static Future<Uint8List> _createEmptyImage(int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint()..color = Colors.white,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      // Return a simple white pixel as fallback
      return Uint8List.fromList([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x06,
        0x00,
        0x00,
        0x00,
        0x1F,
        0x15,
        0xC4,
        0x89,
        0x00,
        0x00,
        0x00,
        0x0A,
        0x49,
        0x44,
        0x41,
        0x54,
        0x78,
        0x9C,
        0x63,
        0x00,
        0x01,
        0x00,
        0x00,
        0x05,
        0x00,
        0x01,
        0x0D,
        0x0A,
        0x2D,
        0xB4,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82,
      ]);
    }

    return byteData.buffer.asUint8List();
  }
}
