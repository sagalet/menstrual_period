import 'package:flutter/material.dart';

/// Shows a dialog to pick a year and month. Returns the chosen month as a
/// [DateTime] (day = 1), or null when cancelled.
Future<DateTime?> showMonthYearPicker(
  BuildContext context,
  DateTime initial,
) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _MonthYearPickerDialog(initial: initial),
  );
}

class _MonthYearPickerDialog extends StatefulWidget {
  const _MonthYearPickerDialog({required this.initial});

  final DateTime initial;

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  static const int _yearSpan = 10;

  late int _year = widget.initial.year;
  late int _month = widget.initial.month;

  @override
  Widget build(BuildContext context) {
    final firstYear = widget.initial.year - _yearSpan;
    final years = List<int>.generate(_yearSpan * 2 + 1, (i) => firstYear + i);

    return AlertDialog(
      title: const Text('選擇年月'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: DropdownButton<int>(
              key: const Key('year_dropdown'),
              isExpanded: true,
              value: _year,
              items: [
                for (final year in years)
                  DropdownMenuItem<int>(
                    value: year,
                    child: Text('$year年'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _year = value);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<int>(
              key: const Key('month_dropdown'),
              isExpanded: true,
              value: _month,
              items: [
                for (var month = 1; month <= 12; month++)
                  DropdownMenuItem<int>(
                    value: month,
                    child: Text('$month月'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _month = value);
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('picker_cancel_button'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          key: const Key('picker_confirm_button'),
          onPressed: () =>
              Navigator.of(context).pop(DateTime(_year, _month)),
          child: const Text('確定'),
        ),
      ],
    );
  }
}
