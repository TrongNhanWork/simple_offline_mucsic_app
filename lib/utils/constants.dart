import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1DB954);

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF191414)
        : const Color(0xFFFFFFFF);
  }

  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF282828)
        : const Color(0xFFEFEFEF);
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : Colors.black54;
  }
}