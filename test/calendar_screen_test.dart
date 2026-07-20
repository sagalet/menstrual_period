import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menstrual_period/main.dart';
import 'package:menstrual_period/models/cycle_phase.dart';

import 'test_helpers.dart';

void main() {
  late TestHarness harness;

  setUp(() async {
    harness = await createTestAppState();
  });

  tearDown(() async {
    await disposeTestAppState(harness);
  });

  testWidgets('shows the year-month header and weekday labels',
      (tester) async {
    await tester.pumpWidget(MenstrualApp(appState: harness.appState));
    await tester.pumpAndSettle();

    final month = harness.appState.focusedMonth;
    expect(find.text('${month.year}年${month.month}月'), findsOneWidget);

    for (final label in ['一', '二', '三', '四', '五', '六', '日']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('settings button navigates to the settings screen',
      (tester) async {
    await tester.pumpWidget(MenstrualApp(appState: harness.appState));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('settings_button')));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('生理期'), findsOneWidget);
    expect(find.text('週期總天數'), findsOneWidget);
  });

  testWidgets('tapping a day opens the action sheet with a cancel button',
      (tester) async {
    await tester.pumpWidget(MenstrualApp(appState: harness.appState));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();

    expect(find.text('設定為月經起始日'), findsOneWidget);
    expect(find.byKey(const Key('cancel_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('cancel_button')));
    await tester.pumpAndSettle();

    expect(find.text('設定為月經起始日'), findsNothing);
  });

  testWidgets('tapping the year-month title jumps to the picked month',
      (tester) async {
    await tester.pumpWidget(MenstrualApp(appState: harness.appState));
    await tester.pumpAndSettle();

    final start = harness.appState.focusedMonth;

    await tester.tap(find.byKey(const Key('month_title')));
    await tester.pumpAndSettle();
    expect(find.text('選擇年月'), findsOneWidget);

    // Pick a different month (use last dropdown item to guarantee a change).
    await tester.tap(find.byKey(const Key('month_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12月').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('picker_confirm_button')));
    await tester.pumpAndSettle();

    expect(harness.appState.focusedMonth.month, 12);
    expect(harness.appState.focusedMonth.year, start.year);
    expect(find.text('${start.year}年12月'), findsOneWidget);
  });

  testWidgets('cancelling the picker keeps the current month', (tester) async {
    await tester.pumpWidget(MenstrualApp(appState: harness.appState));
    await tester.pumpAndSettle();

    final start = harness.appState.focusedMonth;

    await tester.tap(find.byKey(const Key('month_title')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('picker_cancel_button')));
    await tester.pumpAndSettle();

    expect(harness.appState.focusedMonth, start);
  });

  testWidgets('setting a start day records it and colours the phase',
      (tester) async {
    await tester.pumpWidget(MenstrualApp(appState: harness.appState));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('設定為月經起始日'));
    await tester.pumpAndSettle();

    final month = harness.appState.focusedMonth;
    final marked = DateTime(month.year, month.month, 15);
    expect(harness.appState.isStart(marked), isTrue);
    expect(harness.appState.phaseFor(marked), CyclePhase.menstrual);
  });

  testWidgets('tapping an in-cycle day offers clearing the whole cycle',
      (tester) async {
    await tester.pumpWidget(MenstrualApp(appState: harness.appState));
    await tester.pumpAndSettle();

    // Record a start on day 10 so surrounding days fall within the cycle.
    await tester.tap(find.text('10').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('設定為月經起始日'));
    await tester.pumpAndSettle();

    // Tap a later day still inside the cycle (day 12).
    await tester.tap(find.text('12').first);
    await tester.pumpAndSettle();

    expect(find.text('重新設定整個周期'), findsOneWidget);
    expect(find.text('清除整個周期'), findsOneWidget);

    await tester.tap(find.byKey(const Key('clear_cycle_tile')));
    await tester.pumpAndSettle();

    final month = harness.appState.focusedMonth;
    expect(harness.appState.isStart(DateTime(month.year, month.month, 10)),
        isFalse);
    expect(harness.appState.phaseFor(DateTime(month.year, month.month, 12)),
        isNull);
  });
}
