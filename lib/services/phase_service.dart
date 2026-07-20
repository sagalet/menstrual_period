import '../models/app_settings.dart';
import '../models/cycle_phase.dart';
import '../utils/date_only.dart';

/// Pure logic that maps a date to its cycle phase based on recorded start
/// dates and phase settings. Free of storage/UI dependencies for easy testing.
class PhaseService {
  const PhaseService._();

  /// Phases in chronological order.
  static const List<CyclePhase> order = [
    CyclePhase.menstrual,
    CyclePhase.follicular,
    CyclePhase.ovulation,
    CyclePhase.luteal,
  ];

  static int totalDays(AppSettings settings) => settings.totalDays;

  /// Returns the start date of the cycle that covers [date], or null when
  /// [date] is not within any recorded cycle.
  ///
  /// A cycle is governed by the most recent start on/before [date] and spans
  /// exactly [AppSettings.totalDays] days.
  static DateTime? governingStartFor(
    DateTime date,
    List<DateTime> startDates,
    AppSettings settings,
  ) {
    if (startDates.isEmpty) {
      return null;
    }
    final target = dateOnly(date);

    DateTime? governing;
    for (final start in startDates) {
      final normalized = dateOnly(start);
      if (!normalized.isAfter(target)) {
        if (governing == null || normalized.isAfter(governing)) {
          governing = normalized;
        }
      }
    }
    if (governing == null) {
      return null;
    }

    final total = settings.totalDays;
    if (total <= 0) {
      return null;
    }

    final offset = target.difference(governing).inDays;
    if (offset < 0 || offset >= total) {
      return null;
    }
    return governing;
  }

  /// Returns the [CyclePhase] for [date], or null when the date is not covered
  /// by a single cycle following the most recent start on/before it.
  ///
  /// Each recorded start colours exactly one full cycle ([AppSettings.totalDays]
  /// days); dates beyond that window are left uncoloured.
  static CyclePhase? phaseFor(
    DateTime date,
    List<DateTime> startDates,
    AppSettings settings,
  ) {
    final governing = governingStartFor(date, startDates, settings);
    if (governing == null) {
      return null;
    }

    final offset = dateOnly(date).difference(governing).inDays;
    var cumulative = 0;
    for (final phase in order) {
      cumulative += settings.configFor(phase).length;
      if (offset < cumulative) {
        return phase;
      }
    }
    return null;
  }
}
