import 'package:flutter/material.dart';
import 'budget_goal.dart';
import 'transaction.dart';

class BudgetGoalsScreen extends StatelessWidget {
  final List<BudgetGoal> budgetGoals;
  final List<Transaction> transactions;

  const BudgetGoalsScreen({
    super.key,
    required this.transactions,
    required this.budgetGoals,
  });

  @override
  Widget build(BuildContext context) {
    final categoryTotals = calculateCategoryTotals(transactions);
    final totalSpent = calculateExpense(transactions);
    final totalLimit = budgetGoals.fold(
      0.0,
      (sum, goal) => sum + goal.monthlyLimit,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Büdcə Hədəfləri')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E4F),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bu ayın büdcəsi',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatCurrency(totalSpent)} / ${formatCurrency(totalLimit)} ₼',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: totalLimit == 0
                            ? 0
                            : (totalSpent / totalLimit).clamp(0.0, 1.0),
                        color: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...budgetGoals.map((goal) {
              double spent = categoryTotals[goal.category] ?? 0;
              double ratio = goal.monthlyLimit == 0
                  ? 0
                  : spent / goal.monthlyLimit;
              bool isNearLimit = ratio >= goal.notificationThreshold / 100;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            getCategoryIcon(goal.category),
                            color: getCategoryColor(goal.category),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              goal.category,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${formatCurrency(spent)} / ${formatCurrency(goal.monthlyLimit)} ₼',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      //MARK: Progress Indicator
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio.clamp(0.0, 1.0),
                          color: getCategoryColor(goal.category),
                          backgroundColor: Colors.grey.shade200,
                          minHeight: 8,
                        ),
                      ),
                      //MARK: Limit Warning
                      if (isNearLimit) ...{
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${goal.category} limitə yaxınlaşır',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      },
                    ],
                  ),
                ),
              );
            }),
            //MARK: Elevated Button
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E4F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Yeni bir hədəf əlavə et',
                    style: TextStyle(color: Colors.white),
                  ),
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
