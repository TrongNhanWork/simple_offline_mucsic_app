import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:io';

class ColorExtractor {
  static Future<Color> getColorFromImage(String imagePath) async {
    try {
      final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        FileImage(File(imagePath)),
      );
      return generator.dominantColor?.color ?? const Color(0xFF282828);
    } catch (e) {
      return const Color(0xFF282828); // default card background
    }
  }
}
