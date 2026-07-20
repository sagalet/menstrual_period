import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cycle_phase.dart';
import '../services/phase_service.dart';
import '../state/app_state.dart';
import '../widgets/color_palette_selector.dart';

/// Settings screen: adjust each phase's length and background colour, and
/// show the total cycle length.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const int _minLength = 1;
  static const int _maxLength = 30;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final settings = appState.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          for (final phase in PhaseService.order)
            _PhaseSettingCard(
              phase: phase,
              length: settings.configFor(phase).length,
              colorValue: settings.configFor(phase).colorValue,
              minLength: _minLength,
              maxLength: _maxLength,
              onLengthChanged: (value) =>
                  appState.updatePhase(phase, length: value),
              onColorChanged: (value) =>
                  appState.updatePhase(phase, colorValue: value),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '週期總天數',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${settings.totalDays} 天',
                  key: const Key('total_days_value'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseSettingCard extends StatelessWidget {
  const _PhaseSettingCard({
    required this.phase,
    required this.length,
    required this.colorValue,
    required this.minLength,
    required this.maxLength,
    required this.onLengthChanged,
    required this.onColorChanged,
  });

  final CyclePhase phase;
  final int length;
  final int colorValue;
  final int minLength;
  final int maxLength;
  final ValueChanged<int> onLengthChanged;
  final ValueChanged<int> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final keyPrefix = phase.storageKey;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Color(colorValue),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  phase.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  key: Key('${keyPrefix}_length_decrement'),
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: length > minLength
                      ? () => onLengthChanged(length - 1)
                      : null,
                ),
                SizedBox(
                  width: 48,
                  child: Text(
                    '$length天',
                    key: Key('${keyPrefix}_length_value'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  key: Key('${keyPrefix}_length_increment'),
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: length < maxLength
                      ? () => onLengthChanged(length + 1)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('背景顏色', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            ColorPaletteSelector(
              keyPrefix: '${keyPrefix}_color',
              selectedColor: colorValue,
              onSelected: onColorChanged,
            ),
          ],
        ),
      ),
    );
  }
}
