import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/cycle_phase.dart';
import '../services/phase_service.dart';
import '../services/storage_service.dart';
import '../utils/date_only.dart';

/// Holds the UI-facing state and coordinates persistence + phase computation.
class AppState extends ChangeNotifier {
  AppState(this._storage);

  final StorageService _storage;

  DateTime _focusedMonth =
      DateTime(DateTime.now().year, DateTime.now().month);
  Set<DateTime> _startDates = <DateTime>{};
  AppSettings _settings = AppSettings.defaults;

  DateTime get focusedMonth => _focusedMonth;
  AppSettings get settings => _settings;

  /// Total cycle length in days (sum of all phase lengths).
  int get totalCycleDays => _settings.totalDays;

  /// Loads start dates and settings from storage.
  Future<void> load() async {
    _startDates = _storage.getStartDates().map(dateOnly).toSet();
    _settings = _storage.getSettings();
    notifyListeners();
  }

  List<DateTime> get startDates => _startDates.toList();

  /// Whether [date] is a recorded menstrual start day.
  bool isStart(DateTime date) => _startDates.contains(dateOnly(date));

  /// The cycle phase for [date], or null when uncoloured.
  CyclePhase? phaseFor(DateTime date) =>
      PhaseService.phaseFor(date, startDates, _settings);

  /// The background colour for [date], or null when uncoloured.
  Color? colorFor(DateTime date) {
    final phase = phaseFor(date);
    if (phase == null) {
      return null;
    }
    return Color(_settings.configFor(phase).colorValue);
  }

  Future<void> setStart(DateTime date) async {
    final d = dateOnly(date);
    _startDates.add(d);
    await _storage.addStartDate(d);
    notifyListeners();
  }

  Future<void> clearStart(DateTime date) async {
    final d = dateOnly(date);
    _startDates.remove(d);
    await _storage.removeStartDate(d);
    notifyListeners();
  }

  Future<void> updatePhase(
    CyclePhase phase, {
    int? length,
    int? colorValue,
  }) async {
    _settings = _settings.copyWithPhase(
      phase,
      length: length,
      colorValue: colorValue,
    );
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  void setMonth(DateTime month) {
    _focusedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void nextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    notifyListeners();
  }
}
