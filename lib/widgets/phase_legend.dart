import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/cycle_phase.dart';
import '../services/phase_service.dart';

/// A compact legend mapping each phase colour to its label.
class PhaseLegend extends StatelessWidget {
  const PhaseLegend({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: [
          for (final phase in PhaseService.order)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(settings.configFor(phase).colorValue),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
                const SizedBox(width: 4),
                Text(phase.label, style: const TextStyle(fontSize: 12)),
              ],
            ),
        ],
      ),
    );
  }
}
