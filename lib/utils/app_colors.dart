import 'package:flutter/material.dart';

/// Central place for the app's colour palette so screens/widgets stay in sync.
class AppColors {
  AppColors._();

  /// Light khaki / tan background used for the year-month header.
  static const Color monthHeaderBackground = Color(0xFFF5E9C8);

  /// Outline used to highlight "today".
  static const Color todayOutline = Color(0xFF5E35B1);

  /// Border used to mark a recorded menstrual start day.
  static const Color startDayBorder = Color(0xFFAD1457);

  /// Preset colours offered when editing a phase background.
  static const List<int> palette = [
    0xFFF8BBD0, // pink
    0xFFFFCDD2, // red-pink
    0xFFFFE0B2, // light orange
    0xFFFFF9C4, // light yellow
    0xFFC8E6C9, // light green
    0xFFB2EBF2, // light cyan
    0xFFBBDEFB, // light blue
    0xFFD1C4E9, // light purple
    0xFFF5E9C8, // khaki
    0xFFE0E0E0, // grey
  ];
}
