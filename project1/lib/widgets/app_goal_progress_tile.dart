import 'package:flutter/material.dart';

import '../models/goal_model.dart';

import '../core/constants/ui_categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

class AppGoalProgressTile extends StatelessWidget {
  const AppGoalProgressTile({super.key, required this.target});

  final GoalModel target;

  @override
  Widget build(BuildContext context) {
    final localKey = UiCategories.keyForDisplayName(target.category.displayName);
    final category = UiCategories.byKey(localKey);
    final ratio = (target.progressPercentage / 100).clamp(0.0, 1.0);
    final isNearLimit = target.monthlyLimit > 0 &&
        target.progressPercentage >= target.alertThreshold;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UiColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: UiColors.cardShadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, color: category.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${formatCurrency(target.spentAmount)} / ${formatCurrency(target.monthlyLimit)} ${UiStrings.manat}',
                style: const TextStyle(fontSize: 13, color: UiColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              color: category.color,
              backgroundColor: UiColors.grey.shade200,
              minHeight: 8,
            ),
          ),
          if (isNearLimit) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: UiColors.orange, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${category.label} ${UiStrings.closeToLimit}',
                  style: const TextStyle(color: UiColors.orange, fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}