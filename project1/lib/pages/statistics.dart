import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../core/constants/ui_categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/statistics_provider.dart';
import '../models/category_statistics_model.dart';

import '../widgets/app_error_view.dart';
import '../widgets/app_legend_tile.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int touchedIndex = -1;

  List<PieChartSectionData> _buildSections(List<CategoryStatisticItem> entries) {
    final sections = <PieChartSectionData>[];
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final isTouched = i == touchedIndex;
      final localKey = UiCategories.keyForDisplayName(entry.categoryName);
      final category = UiCategories.byKey(localKey);
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
        body: AppErrorView(message: provider.errorMessage!, onRetry: provider.load),
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
              ...entries.map((entry) => AppLegendTile(entry: entry)),
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