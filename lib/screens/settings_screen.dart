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
                Expanded(
                  child: Text(
                    '週期總天數',
                    style: TextStyle(
                      fontSize: _totalDaysFontSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${settings.totalDays} 天',
                  key: const Key('total_days_value'),
                  style: TextStyle(
                    fontSize: _totalDaysFontSize(context),
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

  /// Total-days label rendered at 1.5x the default body text size.
  double _totalDaysFontSize(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.fontSize ?? 14;
    return base * 1.5;
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
        child: Row(
          children: [
            // Square background-colour icon shown to the left of the day-count
            // controls; tapping it opens the colour palette.
            GestureDetector(
              key: Key('${keyPrefix}_color_swatch'),
              onTap: () => _pickColor(context),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Color(colorValue),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
      ),
    );
  }

  Future<void> _pickColor(BuildContext context) async {
    final keyPrefix = phase.storageKey;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('${phase.label}背景顏色'),
          content: ColorPaletteSelector(
            keyPrefix: '${keyPrefix}_color',
            selectedColor: colorValue,
            onSelected: (value) {
              onColorChanged(value);
              Navigator.of(dialogContext).pop();
            },
          ),
          actions: [
            TextButton(
              key: Key('${keyPrefix}_color_cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }
}
