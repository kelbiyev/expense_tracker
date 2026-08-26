import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/budget_target_provider.dart';

import '../routes/app_routes.dart';

import '../models/budget_target.dart';

class BudgetGoalsPage extends StatelessWidget {
  const BudgetGoalsPage({super.key});

  Future<void> _openNewGoalScreen(BuildContext context) async {
    final result = await context.pushNamed<(int, double, double)>(AppRoutes.newGoal.name);

    if (result == null || !context.mounted) return;

    final (categoryId, monthlyLimit, alertThreshold) = result;
    final ok = await context.read<BudgetTargetProvider>().setTarget(
          categoryId: categoryId,
          monthlyLimit: monthlyLimit,
          alertThreshold: alertThreshold,
        );

    if (!context.mounted) return;

    if (!ok) {
      final message = context.read<BudgetTargetProvider>().errorMessage ?? UiStrings.error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetProvider = context.watch<BudgetTargetProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.budgetGoal)),
      body: _buildBody(context, targetProvider),
    );
  }

  Widget _buildBody(BuildContext context, BudgetTargetProvider provider) {
    if (provider.isLoading && provider.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.isEmpty) {
      return Center(
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
      );
    }

    return _buildContent(context, provider.targets);
  }

  Widget _buildContent(BuildContext context, List<BudgetTarget> targets) {
    final totalSpent = targets.fold(0.0, (sum, t) => sum + t.spentAmount);
    final totalLimit = targets.fold(0.0, (sum, t) => sum + t.monthlyLimit);

    return SingleChildScrollView(
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
                      value: totalLimit == 0 ? 0 : (totalSpent / totalLimit).clamp(0.0, 1.0),
                      backgroundColor: UiColors.white.withValues(alpha: 0.2),
                      color: UiColors.white,
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (targets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                UiStrings.noBudgetGoal,
                style: TextStyle(color: UiColors.grey),
              ),
            )
          else
            ...targets.map((target) {
              final localKey = keyForDisplayName(target.category.displayName);
              final category = categoryFor(localKey);
              final ratio = (target.progressPercentage / 100).clamp(0.0, 1.0);
              final isNearLimit = target.monthlyLimit > 0 &&
                  target.progressPercentage >= target.alertThreshold;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: Slidable(
                  key: Key(target.id.toString()),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          context.read<BudgetTargetProvider>().remove(target.id);
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
                              '${formatCurrency(target.spentAmount)} / ${formatCurrency(target.monthlyLimit)} ${UiStrings.manat}',
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
                onPressed: () => _openNewGoalScreen(context),
                child: const Text(UiStrings.addNewGoal, style: TextStyle(color: UiColors.white)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}