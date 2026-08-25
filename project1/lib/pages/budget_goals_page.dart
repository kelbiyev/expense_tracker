import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/transaction_provider.dart';
import '../providers/budget_goal_provider.dart';

import '../routes/app_routes.dart';

import '../models/budget_goal.dart';

class BudgetGoalsPage extends StatelessWidget {
  const BudgetGoalsPage({super.key});

  Map<String, double> _categoryTotals(List transactions) {
    final Map<String, double> result = {};
    for (final t in transactions) {
      if (!t.isExpense) continue;
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  Future<void> _openNewGoalScreen(BuildContext context, List<BudgetGoal> goals) async {
    final allKeys = kCategories.map((c) => c.key).toList();
    final availableKeys =
        allKeys.where((key) => !goals.any((g) => g.category == key)).toList();

    final result = await context.pushNamed<BudgetGoal>(
      AppRoutes.newGoal.name,
      extra: availableKeys,
    );

    if (result != null && context.mounted) {
      await context.read<BudgetGoalProvider>().add(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final goalProvider = context.watch<BudgetGoalProvider>();
    final goals = goalProvider.goals;

    final categoryTotals = _categoryTotals(transactionProvider.transactions);
    final totalSpent = categoryTotals.values.fold(0.0, (sum, v) => sum + v);
    final totalLimit = goals.fold(0.0, (sum, goal) => sum + goal.monthlyLimit);

    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.budgetGoal)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: UiColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: UiColors.cardShadow.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      UiStrings.monthlyBudget,
                      style: TextStyle(color: UiColors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatCurrency(totalSpent)} / ${formatCurrency(totalLimit)} ${UiStrings.manat}',
                      style: const TextStyle(
                        color: UiColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: totalLimit == 0
                            ? 0
                            : (totalSpent / totalLimit).clamp(0.0, 1.0),
                        backgroundColor: UiColors.white.withValues(alpha: 0.2),
                        color: UiColors.white,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (goals.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  UiStrings.noBudgetGoal,
                  style: TextStyle(color: UiColors.grey),
                ),
              )
            else
              ...goals.map((goal) {
                final category = categoryFor(goal.category);
                final spent = categoryTotals[goal.category] ?? 0;
                final ratio = goal.progress(spent);
                final isNearLimit = goal.isNearLimit(spent);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Slidable(
                    key: Key(goal.category),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            context.read<BudgetGoalProvider>().remove(goal.category);
                          },
                          backgroundColor: UiColors.red,
                          foregroundColor: UiColors.white,
                          icon: Icons.delete,
                          label: UiStrings.delete,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ],
                    ),
                    child: Container(
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
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '${formatCurrency(spent)} / ${formatCurrency(goal.monthlyLimit)} ${UiStrings.manat}',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UiColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _openNewGoalScreen(context, goals),
                  child: const Text(UiStrings.addNewGoal, style: TextStyle(color: UiColors.white)),
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