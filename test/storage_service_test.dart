import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:menstrual_period/models/cycle_phase.dart';
import 'package:menstrual_period/services/storage_service.dart';

void main() {
  late Directory tempDir;
  late StorageService storage;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    storage = StorageService();
    await storage.open();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('stores and reads back start dates', () async {
    await storage.addStartDate(DateTime(2026, 3, 5));
    await storage.addStartDate(DateTime(2026, 3, 25));

    final starts = storage.getStartDates();
    expect(starts, contains(DateTime(2026, 3, 5)));
    expect(starts, contains(DateTime(2026, 3, 25)));
    expect(starts.length, 2);
  });

  test('normalizes time components to day granularity', () async {
    await storage.addStartDate(DateTime(2026, 3, 5, 23, 59));

    final starts = storage.getStartDates();
    expect(starts, contains(DateTime(2026, 3, 5)));
  });

  test('removes a start date', () async {
    await storage.addStartDate(DateTime(2026, 3, 5));
    await storage.removeStartDate(DateTime(2026, 3, 5));

    expect(storage.getStartDates(), isEmpty);
  });

  test('returns default phase settings when none saved', () {
    final settings = storage.getSettings();
    expect(settings.configFor(CyclePhase.menstrual).length, 5);
    expect(settings.configFor(CyclePhase.follicular).length, 8);
    expect(settings.configFor(CyclePhase.ovulation).length, 1);
    expect(settings.configFor(CyclePhase.luteal).length, 14);
    expect(settings.totalDays, 28);
    expect(settings.configFor(CyclePhase.menstrual).colorValue, 0xFFF8BBD0);
  });

  test('saves and reads phase settings', () async {
    var settings = storage.getSettings();
    settings = settings.copyWithPhase(
      CyclePhase.menstrual,
      length: 6,
      colorValue: 0xFFBBDEFB,
    );
    await storage.saveSettings(settings);

    final reloaded = storage.getSettings();
    expect(reloaded.configFor(CyclePhase.menstrual).length, 6);
    expect(reloaded.configFor(CyclePhase.menstrual).colorValue, 0xFFBBDEFB);
    expect(reloaded.totalDays, 29);
  });
}
