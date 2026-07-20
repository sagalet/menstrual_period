import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// A single day cell in the calendar grid.
class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.date,
    required this.backgroundColor,
    required this.isStart,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;

  /// Phase background colour, or null when the day is uncoloured.
  final Color? backgroundColor;

  /// Whether this day is a recorded menstrual start day.
  final bool isStart;
  final bool isToday;
  final VoidCallback onTap;

  Border? get _border {
    if (isStart) {
      return Border.all(color: AppColors.startDayBorder, width: 2);
    }
    if (isToday) {
      return Border.all(color: AppColors.todayOutline, width: 2);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: _border,
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: isStart ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
