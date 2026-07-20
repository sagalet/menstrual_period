import 'package:flutter/material.dart';

/// Weekday header row, Monday through Sunday.
class WeekdayRow extends StatelessWidget {
  const WeekdayRow({super.key});

  static const List<String> _labels = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              child: Center(
                child: Text(
                  _labels[i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: i >= 5 ? Colors.red.shade400 : Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
