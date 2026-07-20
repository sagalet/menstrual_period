import 'cycle_phase.dart';

/// Length (in days) and background colour for a single cycle phase.
class PhaseConfig {
  const PhaseConfig({required this.length, required this.colorValue});

  final int length;

  /// ARGB colour value (e.g. 0xFFF8BBD0).
  final int colorValue;

  PhaseConfig copyWith({int? length, int? colorValue}) => PhaseConfig(
        length: length ?? this.length,
        colorValue: colorValue ?? this.colorValue,
      );
}

/// User-configurable settings: one [PhaseConfig] per [CyclePhase].
class AppSettings {
  const AppSettings({required this.phases});

  final Map<CyclePhase, PhaseConfig> phases;

  /// Default lengths/colours per the requirements.
  static const AppSettings defaults = AppSettings(phases: {
    CyclePhase.menstrual: PhaseConfig(length: 5, colorValue: 0xFFF8BBD0),
    CyclePhase.follicular: PhaseConfig(length: 8, colorValue: 0xFFFFE0B2),
    CyclePhase.ovulation: PhaseConfig(length: 1, colorValue: 0xFFC8E6C9),
    CyclePhase.luteal: PhaseConfig(length: 14, colorValue: 0xFFFFF9C4),
  });

  /// Total cycle length in days (sum of all phase lengths).
  int get totalDays =>
      phases.values.fold(0, (sum, config) => sum + config.length);

  PhaseConfig configFor(CyclePhase phase) =>
      phases[phase] ?? defaults.phases[phase]!;

  AppSettings copyWithPhase(
    CyclePhase phase, {
    int? length,
    int? colorValue,
  }) {
    final updated = Map<CyclePhase, PhaseConfig>.from(phases);
    updated[phase] =
        configFor(phase).copyWith(length: length, colorValue: colorValue);
    return AppSettings(phases: updated);
  }
}
