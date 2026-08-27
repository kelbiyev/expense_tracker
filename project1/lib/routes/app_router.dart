import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';
import '../pages/add_transaction_page.dart';
import '../pages/stats_page.dart';
import '../pages/budget_goals_page.dart';
import '../pages/new_goal_page.dart';
import '../pages/notifications_page.dart';

import '../services/notification_service.dart';
import '../services/statistics_service.dart';

import '../providers/notification_provider.dart';
import '../providers/statistics_provider.dart';

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
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => StatisticsProvider(StatisticsService())..load(),
        child: const StatsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.budgetGoals.path,
      name: AppRoutes.budgetGoals.name,
      builder: (context, state) => const BudgetGoalsPage(),
    ),
    GoRoute(
      path: AppRoutes.addTransaction.path,
      name: AppRoutes.addTransaction.name,
      builder: (context, state) => const AddTransactionPage(),
    ),
    GoRoute(
      path: AppRoutes.newGoal.path,
      name: AppRoutes.newGoal.name,
      builder: (context, state) => const NewGoalPage(),
    ),
    GoRoute(
      path: AppRoutes.notifications.path,
      name: AppRoutes.notifications.name,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => NotificationProvider(NotificationService())..load(),
        child: const NotificationsPage(),
      ),
    ),
  ],
);