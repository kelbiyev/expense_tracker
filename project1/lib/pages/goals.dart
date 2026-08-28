import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/goal_provider.dart';

import '../routes/app_routes.dart';

import '../models/goal_model.dart';

import '../widgets/app_error_view.dart';
import '../widgets/app_empty_view.dart';
import '../widgets/app_goal_progress_tile.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  Future<void> _openNewGoalScreen(BuildContext context) async {
    final result = await context.pushNamed<(int, double, double)>(AppRoutes.newGoal.name);

    if (result == null || !context.mounted) return;

    final (categoryId, monthlyLimit, alertThreshold) = result;
    final ok = await context.read<GoalProvider>().setTarget(
          categoryId: categoryId,
          monthlyLimit: monthlyLimit,
          alertThreshold: alertThreshold,
        );

    if (!context.mounted) return;

    if (!ok) {
      final message = context.read<GoalProvider>().errorMessage ?? UiStrings.error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetProvider = context.watch<GoalProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.budgetGoal)),
      body: _buildBody(context, targetProvider),
    );
  }

  Widget _buildBody(BuildContext context, GoalProvider provider) {
    if (provider.isLoading && provider.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.isEmpty) {
      return AppErrorView(message: provider.errorMessage!, onRetry: provider.load);
    }

    return _buildContent(context, provider.targets);
  }

  Widget _buildContent(BuildContext context, List<GoalModel> targets) {
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
            const AppEmptyView(message: UiStrings.noBudgetGoal)
          else
            ...targets.map((target) {
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
                          context.read<GoalProvider>().remove(target.id);
                        },
                        backgroundColor: UiColors.red,
                        foregroundColor: UiColors.white,
                        icon: Icons.delete,
                        label: UiStrings.delete,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ],
                  ),
                  child: AppGoalProgressTile(target: target),
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