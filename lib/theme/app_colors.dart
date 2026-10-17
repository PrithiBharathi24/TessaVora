import 'package:flutter/material.dart';

/// Central place for every color used across Tessa Vora so the whole app
/// stays visually consistent: black background, dark purple surfaces and
/// a glowing purple accent.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0014);
  static const Color surface = Color(0xFF190B2E);
  static const Color surfaceLight = Color(0xFF241340);

  static const Color purpleDark = Color(0xFF4A148C);
  static const Color purple = Color(0xFF7B2FF7);
  static const Color purpleLight = Color(0xFFB388FF);

  static const Color textPrimary = Color(0xFFF5F1FF);
  static const Color textSecondary = Color(0xFFB9A8D9);

  static const Color success = Color(0xFF4CD964);
  static const Color error = Color(0xFFFF6B6B);

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, purpleDark],
  );

  static List<BoxShadow> glow({Color color = purple, double opacity = 0.55}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: 24,
        spreadRadius: 1,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static BoxDecoration cardDecoration({double radius = 20}) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: purple.withOpacity(0.35)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
