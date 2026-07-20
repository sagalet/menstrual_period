import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:menstrual_period/main.dart';
import 'package:menstrual_period/models/cycle_phase.dart';
import 'package:menstrual_period/services/storage_service.dart';
import 'package:menstrual_period/state/app_state.dart';

/// End-to-end flow that can be run on iOS, Android and Web devices:
///   flutter test integration_test/app_flow_test.dart -d <device>
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Hive.initFlutter();
    await Hive.deleteFromDisk();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  Future<AppState> buildLoadedState() async {
    final storage = StorageService();
    await storage.open();
    final appState = AppState(storage);
    await appState.load();
    return appState;
  }

  testWidgets('set a start day, then adjust a phase length',
      (tester) async {
    final appState = await buildLoadedState();
    await tester.pumpWidget(MenstrualApp(appState: appState));
    await tester.pumpAndSettle();

    // Set day 5 as the menstrual start day.
    await tester.tap(find.text('5').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('設定為月經起始日'));
    await tester.pumpAndSettle();

    expect(appState.startDates, isNotEmpty);
    final month = appState.focusedMonth;
    expect(
      appState.phaseFor(DateTime(month.year, month.month, 5)),
      CyclePhase.menstrual,
    );

    // Open settings and change the menstrual phase length.
    await tester.tap(find.byKey(const Key('settings_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('menstrual_length_increment')));
    await tester.pumpAndSettle();

    expect(appState.settings.configFor(CyclePhase.menstrual).length, 6);
    expect(appState.totalCycleDays, 29);
    expect(find.text('29 天'), findsOneWidget);
  });
}
