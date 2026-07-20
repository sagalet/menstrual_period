import 'dart:io';

import 'package:hive/hive.dart';
import 'package:menstrual_period/services/storage_service.dart';
import 'package:menstrual_period/state/app_state.dart';

/// Test helper: initializes Hive in a fresh temp directory and returns a
/// loaded [AppState]. Call [disposeTestAppState] in tearDown.
class TestHarness {
  TestHarness(this.tempDir, this.appState);

  final Directory tempDir;
  final AppState appState;
}

Future<TestHarness> createTestAppState() async {
  final tempDir = await Directory.systemTemp.createTemp('hive_widget_test');
  Hive.init(tempDir.path);
  final storage = StorageService();
  await storage.open();
  final appState = AppState(storage);
  await appState.load();
  return TestHarness(tempDir, appState);
}

Future<void> disposeTestAppState(TestHarness harness) async {
  await Hive.deleteFromDisk();
  await harness.tempDir.delete(recursive: true);
}
