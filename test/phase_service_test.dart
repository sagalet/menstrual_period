import 'package:flutter_test/flutter_test.dart';
import 'package:menstrual_period/models/app_settings.dart';
import 'package:menstrual_period/models/cycle_phase.dart';
import 'package:menstrual_period/services/phase_service.dart';

void main() {
  // Defaults: menstrual 5 / follicular 8 / ovulation 1 / luteal 14 = 28 total.
  const settings = AppSettings.defaults;
  final start = DateTime(2026, 1, 1);

  test('totalDays is the sum of phase lengths', () {
    expect(settings.totalDays, 28);
  });

  test('no start dates -> null', () {
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 1), const [], settings),
      isNull,
    );
  });

  test('date before first start -> null', () {
    expect(
      PhaseService.phaseFor(DateTime(2025, 12, 31), [start], settings),
      isNull,
    );
  });

  test('menstrual phase covers offsets 0..4 (Jan 1..5)', () {
    for (var day = 1; day <= 5; day++) {
      expect(
        PhaseService.phaseFor(DateTime(2026, 1, day), [start], settings),
        CyclePhase.menstrual,
        reason: 'Jan $day',
      );
    }
  });

  test('follicular phase covers offsets 5..12 (Jan 6..13)', () {
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 6), [start], settings),
      CyclePhase.follicular,
    );
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 13), [start], settings),
      CyclePhase.follicular,
    );
  });

  test('ovulation phase is the single offset 13 (Jan 14)', () {
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 14), [start], settings),
      CyclePhase.ovulation,
    );
  });

  test('luteal phase covers offsets 14..27 (Jan 15..28)', () {
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 15), [start], settings),
      CyclePhase.luteal,
    );
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 28), [start], settings),
      CyclePhase.luteal,
    );
  });

  test('beyond one full cycle -> null (offset >= 28)', () {
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 29), [start], settings),
      isNull,
    );
  });

  test('a later start date takes over from the previous cycle', () {
    final secondStart = DateTime(2026, 1, 20);
    // Jan 20 is governed by the newer start -> menstrual (offset 0).
    expect(
      PhaseService.phaseFor(
        DateTime(2026, 1, 20),
        [start, secondStart],
        settings,
      ),
      CyclePhase.menstrual,
    );
    // Jan 19 is still governed by the first start (offset 18) -> luteal.
    expect(
      PhaseService.phaseFor(
        DateTime(2026, 1, 19),
        [start, secondStart],
        settings,
      ),
      CyclePhase.luteal,
    );
  });

  test('zero total length -> null', () {
    const empty = AppSettings(phases: {
      CyclePhase.menstrual: PhaseConfig(length: 0, colorValue: 0xFFFFFFFF),
      CyclePhase.follicular: PhaseConfig(length: 0, colorValue: 0xFFFFFFFF),
      CyclePhase.ovulation: PhaseConfig(length: 0, colorValue: 0xFFFFFFFF),
      CyclePhase.luteal: PhaseConfig(length: 0, colorValue: 0xFFFFFFFF),
    });
    expect(
      PhaseService.phaseFor(DateTime(2026, 1, 1), [start], empty),
      isNull,
    );
  });

  group('governingStartFor', () {
    test('returns the start for any day within the cycle', () {
      for (final day in [1, 5, 14, 28]) {
        expect(
          PhaseService.governingStartFor(
            DateTime(2026, 1, day),
            [start],
            settings,
          ),
          start,
          reason: 'Jan $day',
        );
      }
    });

    test('returns null before the first start or beyond the cycle', () {
      expect(
        PhaseService.governingStartFor(
          DateTime(2025, 12, 31),
          [start],
          settings,
        ),
        isNull,
      );
      expect(
        PhaseService.governingStartFor(
          DateTime(2026, 1, 29),
          [start],
          settings,
        ),
        isNull,
      );
    });

    test('picks the most recent start on/before the date', () {
      final secondStart = DateTime(2026, 1, 20);
      expect(
        PhaseService.governingStartFor(
          DateTime(2026, 1, 22),
          [start, secondStart],
          settings,
        ),
        secondStart,
      );
      expect(
        PhaseService.governingStartFor(
          DateTime(2026, 1, 19),
          [start, secondStart],
          settings,
        ),
        start,
      );
    });
  });
}
