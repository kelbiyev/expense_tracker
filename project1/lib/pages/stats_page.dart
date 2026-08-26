import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../core/categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/statistics_provider.dart';
import '../models/category_statistics.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int touchedIndex = -1;

  List<PieChartSectionData> _buildSections(List<CategoryStatEntry> entries) {
    final sections = <PieChartSectionData>[];
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final isTouched = i == touchedIndex;
      final localKey = keyForDisplayName(entry.categoryName);
      final category = categoryFor(localKey);
      sections.add(
        PieChartSectionData(
          value: entry.totalAmount,
          title: isTouched ? category.label : '',
          color: category.color,
          radius: isTouched ? 70 : 60,
          titleStyle: const TextStyle(color: UiColors.black87, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      );
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StatisticsProvider>();
    final stats = provider.categoryStats;
    if (provider.isLoading && stats == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(UiStrings.categoryStats)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorMessage != null && stats == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(UiStrings.categoryStats)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: provider.load, child: const Text(UiStrings.retry)),
              ],
            ),
          ),
        ),
      );
    }

    if (stats == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(UiStrings.categoryStats)),
        body: const SizedBox.shrink(),
      );
    }

    final entries = stats.categories;

    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.categoryStats)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: _buildSections(entries),
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...entries.map((entry) {
                final localKey = keyForDisplayName(entry.categoryName);
                final category = categoryFor(localKey);
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
              }),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(UiStrings.monthlyExpense, style: TextStyle(color: UiColors.grey)),
                  Text('${formatCurrency(stats.totalExpense)} ${UiStrings.manat}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}