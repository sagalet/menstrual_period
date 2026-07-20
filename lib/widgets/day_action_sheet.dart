import 'package:flutter/material.dart';

/// Actions the user can pick from the day menu.
enum DayAction { setStart, resetCycle, clearCycle }

/// Shows the per-day action menu with a top-right cancel button.
///
/// [isInCycle] indicates whether the tapped day already falls within a recorded
/// cycle. When it does, the menu offers to re-set or clear the entire cycle;
/// otherwise it offers to set the day as a new menstrual start.
///
/// Returns the chosen [DayAction], or null when cancelled/dismissed.
Future<DayAction?> showDayActionSheet(
  BuildContext context,
  DateTime date, {
  required bool isInCycle,
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
            if (isInCycle) ...[
              ListTile(
                key: const Key('reset_cycle_tile'),
                leading: const Icon(Icons.play_arrow),
                title: const Text('重新設定整個周期'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(DayAction.resetCycle),
              ),
              ListTile(
                key: const Key('clear_cycle_tile'),
                leading: const Icon(Icons.clear),
                title: const Text('清除整個周期'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(DayAction.clearCycle),
              ),
            ] else
              ListTile(
                key: const Key('set_start_tile'),
                leading: const Icon(Icons.play_arrow),
                title: const Text('設定為月經起始日'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(DayAction.setStart),
              ),
          ],
        ),
      );
    },
  );
}
