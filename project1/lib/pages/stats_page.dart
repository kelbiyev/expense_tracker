import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../core/categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/transaction_provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int touchedIndex = -1;

  Map<String, double> _categoryTotals(List<dynamic> transactions) {
    final Map<String, double> result = {};
    for (final t in transactions) {
      if (!t.isExpense) continue;
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  List<PieChartSectionData> _buildSections(Map<String, double> categoryTotals) {
    final sections = <PieChartSectionData>[];
    int index = 0;
    categoryTotals.forEach((categoryKey, total) {
      final bool isTouched = index == touchedIndex;
      final category = categoryFor(categoryKey);
      sections.add(
        PieChartSectionData(
          value: total,
          title: isTouched ? category.label : '',
          color: category.color,
          radius: isTouched ? 70 : 60,
          titleStyle: const TextStyle(color: UiColors.black87, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      );
      index++;
    });
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final categoryTotals = _categoryTotals(provider.transactions);
    final total = categoryTotals.values.fold(0.0, (sum, value) => sum + value);

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
                    sections: _buildSections(categoryTotals),
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
              ...categoryTotals.entries.map((entry) {
                final category = categoryFor(entry.key);
                final percentage = total == 0 ? 0 : (entry.value / total * 100);
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
                      Text('${percentage.round()}%', style: const TextStyle(fontSize: 16, color: UiColors.grey)),
                    ],
                  ),
                );
              }),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(UiStrings.monthlyExpense, style: TextStyle(color: UiColors.grey)),
                  Text('${formatCurrency(provider.expense)} ${UiStrings.manat}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}