import 'package:flutter/material.dart';

import '../utils/date_only.dart';
import 'day_cell.dart';

/// Renders the days of [month] in a Monday-first 7-column grid.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.month,
    required this.colorFor,
    required this.isStart,
    required this.onDayTap,
  });

  final DateTime month;
  final Color? Function(DateTime date) colorFor;
  final bool Function(DateTime date) isStart;
  final void Function(DateTime date) onDayTap;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Monday == 1 in DateTime.weekday, so leading blanks = weekday - 1.
    final leadingBlanks = firstOfMonth.weekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final today = dateOnly(DateTime.now());

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final cellBorder = Border.all(color: Colors.black12, width: 0.5);
        if (index < leadingBlanks) {
          return DecoratedBox(
            decoration: BoxDecoration(border: cellBorder),
          );
        }
        final day = index - leadingBlanks + 1;
        final date = DateTime(month.year, month.month, day);
        return DecoratedBox(
          decoration: BoxDecoration(border: cellBorder),
          child: DayCell(
            date: date,
            backgroundColor: colorFor(date),
            isStart: isStart(date),
            isToday: isSameDay(date, today),
            onTap: () => onDayTap(date),
          ),
        );
      },
    );
  }
}
