import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';
import '../pages/add_transaction_page.dart';
import '../pages/stats_page.dart';
import '../pages/budget_goals_page.dart';

import '../models/transaction.dart';
import '../models/budget_goal.dart';

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home.path,
  routes: [
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.stats.path,
      name: AppRoutes.stats.name,
      builder: (context, state) => const StatsPage(),
  ),
    GoRoute(
      path: AppRoutes.budgetGoals.path,
      name: AppRoutes.budgetGoals.name,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return BudgetGoalsPage(
          transactions: args['transactions'] as List<Transaction>,
          budgetGoals: args['budgetGoals'] as List<BudgetGoal>,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addTransaction.path,
      name: AppRoutes.addTransaction.name,
      builder: (context, state) => const AddTransactionPage(),
    ),
  ],
);