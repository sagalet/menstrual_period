import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// A row of preset colour swatches. The currently selected colour is marked
/// with a check and a heavier border.
class ColorPaletteSelector extends StatelessWidget {
  const ColorPaletteSelector({
    super.key,
    required this.selectedColor,
    required this.onSelected,
    this.keyPrefix,
  });

  final int selectedColor;
  final ValueChanged<int> onSelected;
  final String? keyPrefix;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in AppColors.palette)
          GestureDetector(
            key: keyPrefix != null ? Key('${keyPrefix}_$value') : null,
            onTap: () => onSelected(value),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(value),
                shape: BoxShape.circle,
                border: Border.all(
                  color: value == selectedColor
                      ? Colors.black87
                      : Colors.black12,
                  width: value == selectedColor ? 3 : 1,
                ),
              ),
              child: value == selectedColor
                  ? const Icon(Icons.check, size: 18, color: Colors.black54)
                  : null,
            ),
          ),
      ],
    );
  }
}
