// pages/budget_goals_page.dart
import 'package:flutter/material.dart';
import '../core/ui_strings.dart';
import '../core/ui_colors.dart';
import '../models/transaction.dart';
import '../models/budget_goal.dart';
import '../core/categories.dart';
import '../core/formatters.dart';
import '../repositories/budget_goal_repository.dart';
import 'new_goal_page.dart'; // временно — старый файл, пока не переписан

class BudgetGoalsPage extends StatefulWidget {
  final List<Transaction> transactions;
  final List<BudgetGoal> budgetGoals;

  const BudgetGoalsPage({super.key, required this.transactions, required this.budgetGoals});

  @override
  State<BudgetGoalsPage> createState() => _BudgetGoalsPageState();
}

class _BudgetGoalsPageState extends State<BudgetGoalsPage> {
  final _repository = BudgetGoalRepository();
  late List<BudgetGoal> goals;

  @override
  void initState() {
    super.initState();
    goals = List.from(widget.budgetGoals);
  }

  Map<String, double> _categoryTotals() {
    final Map<String, double> result = {};
    for (final t in widget.transactions) {
      if (!t.isExpense) continue;
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  Future<void> _openNewGoalScreen() async {
    final allKeys = kCategories.map((c) => c.key).toList();
    final availableKeys = allKeys.where((key) => !goals.any((g) => g.category == key)).toList();

    final result = await Navigator.push<BudgetGoal>(
      context,
      MaterialPageRoute(builder: (context) => NewGoalPage(availableCategories: availableKeys)),
    );

    if (result != null) {
      setState(() {
        goals.add(result);
      });
      await _repository.save(goals);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _categoryTotals();
    final totalSpent = categoryTotals.values.fold(0.0, (sum, v) => sum + v);
    final totalLimit = goals.fold(0.0, (sum, goal) => sum + goal.monthlyLimit);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.budgetGoal)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withValues(alpha: 0.15), 
                      blurRadius: 12, 
                      offset: const Offset(0, 6)
                      )
                    ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bu ayın büdcəsi', style: TextStyle(color: AppColors.white70, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('${formatCurrency(totalSpent)} / ${formatCurrency(totalLimit)} ₼',
                        style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: totalLimit == 0 ? 0 : (totalSpent / totalLimit).clamp(0.0, 1.0),
                        backgroundColor: AppColors.white.withValues(alpha: 0.2),
                        color: AppColors.white,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...goals.map((goal) {
              final category = categoryFor(goal.category);
              final spent = categoryTotals[goal.category] ?? 0;
              final ratio = goal.progress(spent);
              final isNearLimit = goal.isNearLimit(spent);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(category.icon, color: category.color),
                          const SizedBox(width: 8),
                          Expanded(child: Text(category.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                          Text('${formatCurrency(spent)} / ${formatCurrency(goal.monthlyLimit)} ₼',
                              style: const TextStyle(fontSize: 13, color: AppColors.grey)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(value: ratio, color: category.color, backgroundColor: AppColors.grey.shade200, minHeight: 8),
                      ),
                      if (isNearLimit) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppColors.orange, size: 16),
                            const SizedBox(width: 6),
                            Text('${category.label} limitə yaxınlaşır', style: const TextStyle(color: AppColors.orange, fontSize: 12)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: _openNewGoalScreen,
                  child: const Text('Yeni bir hədəf əlavə et', style: TextStyle(color: AppColors.white)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}