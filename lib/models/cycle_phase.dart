/// The four phases of a menstrual cycle, in chronological order.
enum CyclePhase {
  menstrual,
  follicular,
  ovulation,
  luteal,
}

extension CyclePhaseInfo on CyclePhase {
  /// Human-readable Chinese label.
  String get label {
    switch (this) {
      case CyclePhase.menstrual:
        return '生理期';
      case CyclePhase.follicular:
        return '濾泡期';
      case CyclePhase.ovulation:
        return '排卵期';
      case CyclePhase.luteal:
        return '黃體期';
    }
  }

  /// Stable key used for local storage.
  String get storageKey => name;
}
