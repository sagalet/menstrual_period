import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Year-month header with a light khaki background and month navigation.
class MonthHeader extends StatelessWidget {
  const MonthHeader({
    super.key,
    required this.month,
    required this.onPrevious,
    required this.onNext,
    required this.onTitleTap,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onTitleTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.monthHeaderBackground,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            key: const Key('previous_month'),
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
            tooltip: '上個月',
          ),
          InkWell(
            key: const Key('month_title'),
            onTap: onTitleTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                '${month.year}年${month.month}月',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('next_month'),
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
            tooltip: '下個月',
          ),
        ],
      ),
    );
  }
}
