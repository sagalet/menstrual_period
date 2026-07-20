import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/day_action_sheet.dart';
import '../widgets/month_header.dart';
import '../widgets/month_year_picker.dart';
import '../widgets/phase_legend.dart';
import '../widgets/weekday_row.dart';
import 'settings_screen.dart';

/// Main screen: a monthly calendar with a settings entry point.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  Future<void> _handleDayTap(BuildContext context, DateTime date) async {
    final appState = context.read<AppState>();
    final action = await showDayActionSheet(
      context,
      date,
      isStart: appState.isStart(date),
    );
    switch (action) {
      case DayAction.setStart:
        await appState.setStart(date);
        break;
      case DayAction.clearStart:
        await appState.clearStart(date);
        break;
      case null:
        break;
    }
  }

  Future<void> _handleTitleTap(BuildContext context) async {
    final appState = context.read<AppState>();
    final picked =
        await showMonthYearPicker(context, appState.focusedMonth);
    if (picked != null) {
      appState.setMonth(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('月經記錄'),
        actions: [
          IconButton(
            key: const Key('settings_button'),
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          MonthHeader(
            month: appState.focusedMonth,
            onPrevious: appState.previousMonth,
            onNext: appState.nextMonth,
            onTitleTap: () => _handleTitleTap(context),
          ),
          const WeekdayRow(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: CalendarGrid(
                month: appState.focusedMonth,
                colorFor: appState.colorFor,
                isStart: appState.isStart,
                onDayTap: (date) => _handleDayTap(context, date),
              ),
            ),
          ),
          const Divider(height: 1),
          PhaseLegend(settings: appState.settings),
        ],
      ),
    );
  }
}
