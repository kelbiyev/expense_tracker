import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transaction.dart';

class StatsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const StatsScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = calculateCategoryTotals(transactions);
    final totalExpense = calculateExpense(transactions);
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
                  PieChartData(sections: buildSections(categoryTotals)),
                ),
              ),
              const SizedBox(height: 16),
              ...categoryTotals.entries.map((entry) {
                double percentage = total == 0
                    ? 0
                    : (entry.value / total * 100);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: getCategoryColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        '${percentage.round()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bu ay ümumi xərc',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${formatCurrency(totalExpense)} ₼',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
