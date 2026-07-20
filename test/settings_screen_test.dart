import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menstrual_period/models/cycle_phase.dart';
import 'package:menstrual_period/screens/settings_screen.dart';
import 'package:menstrual_period/state/app_state.dart';
import 'package:provider/provider.dart';

import 'test_helpers.dart';

Widget _wrap(AppState appState) {
  return ChangeNotifierProvider<AppState>.value(
    value: appState,
    child: const MaterialApp(home: SettingsScreen()),
  );
}

void main() {
  late TestHarness harness;

  setUp(() async {
    harness = await createTestAppState();
  });

  tearDown(() async {
    await disposeTestAppState(harness);
  });

  testWidgets('shows the four phases and default total days', (tester) async {
    await tester.pumpWidget(_wrap(harness.appState));
    await tester.pumpAndSettle();

    expect(find.text('生理期'), findsOneWidget);
    expect(find.text('濾泡期'), findsOneWidget);
    expect(find.text('排卵期'), findsOneWidget);
    expect(find.text('黃體期'), findsOneWidget);

    expect(find.byKey(const Key('menstrual_length_value')), findsOneWidget);
    expect(find.text('5天'), findsOneWidget);
    expect(find.text('8天'), findsOneWidget);
    expect(find.text('14天'), findsOneWidget);
    expect(find.text('28 天'), findsOneWidget);
  });

  testWidgets('incrementing a phase length updates total and persists',
      (tester) async {
    await tester.pumpWidget(_wrap(harness.appState));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('menstrual_length_increment')));
    await tester.pumpAndSettle();

    expect(harness.appState.settings.configFor(CyclePhase.menstrual).length, 6);
    expect(find.text('29 天'), findsOneWidget);
  });

  testWidgets('selecting a colour updates the phase colour', (tester) async {
    await tester.pumpWidget(_wrap(harness.appState));
    await tester.pumpAndSettle();

    // Open the palette via the square colour swatch, then pick light-blue.
    await tester.tap(find.byKey(const Key('menstrual_color_swatch')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('menstrual_color_4290502395')));
    await tester.pumpAndSettle();

    expect(
      harness.appState.settings.configFor(CyclePhase.menstrual).colorValue,
      0xFFBBDEFB,
    );
  });

  testWidgets('total-days label renders at 1.5x the default font size',
      (tester) async {
    await tester.pumpWidget(_wrap(harness.appState));
    await tester.pumpAndSettle();

    final totalText = tester.widget<Text>(
      find.byKey(const Key('total_days_value')),
    );
    final base = DefaultTextStyle.of(
      tester.element(find.byKey(const Key('total_days_value'))),
    ).style.fontSize ?? 14;
    expect(totalText.style?.fontSize, closeTo(base * 1.5, 0.01));
  });
}
