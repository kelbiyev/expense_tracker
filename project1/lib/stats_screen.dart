import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transaction.dart';

class StatsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const StatsScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = calculateCategoryTotals(transactions);
    return Scaffold(
      appBar: AppBar(title: const Text('Kateqoriya Statistikası')),
      body: Center(
        child: SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(sections: buildSections(categoryTotals)),
          ),
        ),
      ),
    );
  }
}
