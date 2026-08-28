import 'package:flutter/material.dart';

import '../models/category_statistics_model.dart';

import '../core/constants/ui_categories.dart';
import '../core/constants/ui_colors.dart';

class AppLegendTile extends StatelessWidget {
  const AppLegendTile({super.key, required this.entry});

  final CategoryStatisticItem entry;

  @override
  Widget build(BuildContext context) {
    final localKey = UiCategories.keyForDisplayName(entry.categoryName);
    final category = UiCategories.byKey(localKey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: category.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(category.label, style: const TextStyle(fontSize: 16))),
          Text('${entry.percentage.round()}%', style: const TextStyle(fontSize: 16, color: UiColors.grey)),
        ],
      ),
    );
  }
}