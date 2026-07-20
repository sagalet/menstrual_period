import 'package:hive/hive.dart';

import '../models/app_settings.dart';
import '../models/cycle_phase.dart';
import '../utils/date_only.dart';

/// Local, offline persistence backed by Hive.
///
/// Data is stored using plain primitives (no generated TypeAdapters):
///  * [startsBoxName]: key = `yyyy-MM-dd`, value = `true` (recorded start day).
///  * [settingsBoxName]: keys `<phase>_length` / `<phase>_color` -> int.
///
/// [Hive] must be initialized (e.g. `Hive.initFlutter()` in the app or
/// `Hive.init(path)` in tests) before calling [open].
class StorageService {
  static const String startsBoxName = 'starts';
  static const String settingsBoxName = 'settings';

  late Box<dynamic> _starts;
  late Box<dynamic> _settings;

  Future<void> open() async {
    _starts = await Hive.openBox<dynamic>(startsBoxName);
    _settings = await Hive.openBox<dynamic>(settingsBoxName);
  }

  String _key(DateTime date) {
    final d = dateOnly(date);
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  /// Returns all recorded menstrual start dates.
  List<DateTime> getStartDates() {
    final result = <DateTime>[];
    for (final key in _starts.keys) {
      if (key is! String) {
        continue;
      }
      final parts = key.split('-');
      if (parts.length != 3) {
        continue;
      }
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (year == null || month == null || day == null) {
        continue;
      }
      result.add(DateTime(year, month, day));
    }
    return result;
  }

  Future<void> addStartDate(DateTime date) async {
    await _starts.put(_key(date), true);
  }

  Future<void> removeStartDate(DateTime date) async {
    await _starts.delete(_key(date));
  }

  AppSettings getSettings() {
    final phases = <CyclePhase, PhaseConfig>{};
    for (final phase in CyclePhase.values) {
      final defaults = AppSettings.defaults.configFor(phase);
      final length = _settings.get(
        '${phase.storageKey}_length',
        defaultValue: defaults.length,
      );
      final color = _settings.get(
        '${phase.storageKey}_color',
        defaultValue: defaults.colorValue,
      );
      phases[phase] = PhaseConfig(
        length: length is int ? length : defaults.length,
        colorValue: color is int ? color : defaults.colorValue,
      );
    }
    return AppSettings(phases: phases);
  }

  Future<void> saveSettings(AppSettings settings) async {
    for (final phase in CyclePhase.values) {
      final config = settings.configFor(phase);
      await _settings.put('${phase.storageKey}_length', config.length);
      await _settings.put('${phase.storageKey}_color', config.colorValue);
    }
  }
}
