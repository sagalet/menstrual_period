import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/calendar_screen.dart';
import 'services/storage_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final storage = StorageService();
  await storage.open();

  final appState = AppState(storage);
  await appState.load();

  runApp(MenstrualApp(appState: appState));
}

/// Root widget. Accepts an [AppState] so it can be reused directly in tests.
class MenstrualApp extends StatelessWidget {
  const MenstrualApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MaterialApp(
        title: '月經記錄',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD81B60)),
          useMaterial3: true,
        ),
        home: const CalendarScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
