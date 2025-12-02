import 'dart:convert';
import 'package:aidrawing/domain/models/drawing.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiService {
  static const apiUrl = "https://api.adavii.com/ai/chat";

  // Build context prompt for drawing
  static String buildContextPrompt({
    required String theme,
    String? subTheme,
    String? style,
    int complexity = 1, // 1: Simple, 2: Medium, 3: Complex
  }) {
    final complexityLevel = [
      "very simple with 10-20 lines",
      "medium complexity with 20-40 lines",
      "complex with 40-60 lines",
    ][complexity - 1];

    return """
You are an AI that creates simple black-and-white line drawing outlines for children to color.

Theme: $theme
${subTheme != null ? "Sub-theme: $subTheme" : ""}
${style != null ? "Style: $style" : ""}

INSTRUCTIONS:
1. Create a line drawing outline suitable for children aged 4-10
2. Make it $complexityLevel
3. Use only black lines on white background
4. No shading, no colors, no gradients
5. Lines should be clear and distinct
6. The drawing should be centered in a 300x300 pixel canvas
7. Return ONLY a JSON object with this exact structure:
{
  "title": "Descriptive title of the drawing",
  "description": "Short description for kids",
  "strokes": [
    {"x1": 50, "y1": 50, "x2": 150, "y2": 150, "thickness": 2},
    ...
  ],
  "boundingBox": {"x": 0, "y": 0, "width": 300, "height": 300},
  "hints": ["color suggestion 1", "color suggestion 2", "color suggestion 3"]
}
""";
  }

  // Extract JSON from AI response
  static Map<String, dynamic> _extractDrawing(String input) {
    try {
      // Clean the input
      String cleaned = input.trim();

      // Find JSON object
      final jsonStart = cleaned.indexOf('{');
      final jsonEnd = cleaned.lastIndexOf('}');

      if (jsonStart == -1 || jsonEnd == -1) {
        throw Exception("No JSON found in response");
      }

      final jsonString = cleaned.substring(jsonStart, jsonEnd + 1);
      final decoded = json.decode(jsonString) as Map<String, dynamic>;

      // Validate structure
      if (!decoded.containsKey('title') || !decoded.containsKey('strokes')) {
        throw Exception("Invalid JSON structure");
      }

      return decoded;
    } catch (e) {
      if (kDebugMode) {
        print("Error extracting drawing: $e");
        print("Raw input: $input");
      }

      // Return a fallback drawing
      return _createFallbackDrawing();
    }
  }

  // Fallback drawing if AI fails
  static Map<String, dynamic> _createFallbackDrawing() {
    return {
      "title": "Friendly Dinosaur",
      "description": "A cute dinosaur waiting for colors!",
      "strokes": [
        {"x1": 100, "y1": 100, "x2": 200, "y2": 100, "thickness": 3},
        {"x1": 200, "y1": 100, "x2": 200, "y2": 200, "thickness": 3},
        {"x1": 200, "y1": 200, "x2": 100, "y2": 200, "thickness": 3},
        {"x1": 100, "y1": 200, "x2": 100, "y2": 100, "thickness": 3},
        {"x1": 150, "y1": 100, "x2": 150, "y2": 80, "thickness": 2},
        {"x1": 150, "y1": 80, "x2": 170, "y2": 80, "thickness": 2},
      ],
      "boundingBox": {"x": 0, "y": 0, "width": 300, "height": 300},
      "hints": ["Green body", "Yellow belly", "Red spikes"],
    };
  }

  // Generate drawing from AI
  static Future<Map<String, dynamic>> generateDrawing({
    required String theme,
    String? subTheme,
    String? style,
    int complexity = 1,
  }) async {
    try {
      final prompt = buildContextPrompt(
        theme: theme,
        subTheme: subTheme,
        style: style,
        complexity: complexity,
      );

      final body = {
        "context": prompt,
        "command": jsonEncode({
          "action": "generate_drawing",
          "theme": theme,
          "subTheme": subTheme,
          "style": style,
          "complexity": complexity,
          "timestamp": DateTime.now().toIso8601String(),
        }),
      };

      if (kDebugMode) {
        print("Sending request to AI API...");
      }

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Handle different response formats
        if (responseData.containsKey('content')) {
          final content = responseData['content'];
          return _extractDrawing(content);
        } else if (responseData.containsKey('message')) {
          return _extractDrawing(responseData['message']);
        } else {
          return _extractDrawing(response.body);
        }
      } else {
        if (kDebugMode) {
          print("AI API Error: ${response.statusCode}");
          print("Response: ${response.body}");
        }
        throw Exception(
          "Failed to generate drawing. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("AI Service Error: $e");
      }
      return _createFallbackDrawing();
    }
  }

  // Convert AI data to Drawing object
  static Drawing aiDataToDrawing(Map<String, dynamic> aiData) {
    return Drawing(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: aiData['title'] ?? 'AI Drawing',
      category: 'AI Generated',
      description: aiData['description'] ?? 'An AI generated drawing',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isFavorite: false,
      completionPercentage: 0.0,
      aiData: aiData, // Store the raw AI data for rendering
    );
  }
}
