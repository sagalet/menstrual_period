import 'package:flutter/material.dart';

/// Actions the user can pick from the day menu.
enum DayAction { setStart, clearStart }

/// Shows the per-day action menu with a top-right cancel button.
///
/// [isStart] indicates whether the tapped day is already a recorded start day,
/// used to show the appropriate options.
///
/// Returns the chosen [DayAction], or null when cancelled/dismissed.
Future<DayAction?> showDayActionSheet(
  BuildContext context,
  DateTime date, {
  required bool isStart,
}) {
  return showModalBottomSheet<DayAction>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 4, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${date.year}年${date.month}月${date.day}日',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('cancel_button'),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: '取消',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('設定為月經起始日'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(DayAction.setStart),
            ),
            ListTile(
              enabled: isStart,
              leading: const Icon(Icons.clear),
              title: const Text('清除月經起始日'),
              onTap: () =>
                  Navigator.of(sheetContext).pop(DayAction.clearStart),
            ),
          ],
        ),
      );
    },
  );
}
