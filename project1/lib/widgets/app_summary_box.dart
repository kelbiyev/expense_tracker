import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

class AppSummaryBox extends StatelessWidget {
  const AppSummaryBox({super.key, required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: UiColors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: UiColors.white70, fontSize: 14)),
          Text('${formatCurrency(value)} ${UiStrings.manat}', style: const TextStyle(color: UiColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}