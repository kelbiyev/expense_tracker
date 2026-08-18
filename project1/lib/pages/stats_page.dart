import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../core/categories.dart';
import '../core/formatters.dart';

class StatsPage extends StatefulWidget {
  final List<Transaction> transactions;

  const StatsPage({super.key, required this.transactions});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int touchedIndex = -1;

  Map<String, double> _categoryTotals() {
    final Map<String, double> result = {};
    for (final t in widget.transactions) {
      if (!t.isExpense) continue;
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  double _totalExpense() =>
      widget.transactions.where((t) => t.isExpense).fold(0.0, (sum, t) => sum + t.amount);

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
          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      );
      index++;
    });
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _categoryTotals();
    final totalExpense = _totalExpense();
    final total = categoryTotals.values.fold(0.0, (sum, value) => sum + value);

    return Scaffold(
      appBar: AppBar(title: const Text('Kateqoriya Statistikası')),
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
                      Text('${percentage.round()}%', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                );
              }),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Bu ay ümumi xərc', style: TextStyle(color: Colors.grey)),
                  Text('${formatCurrency(totalExpense)} ₼', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}