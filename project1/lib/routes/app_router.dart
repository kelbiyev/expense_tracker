import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';
import '../pages/add_transaction_page.dart';
import '../pages/stats_page.dart';
import '../pages/budget_goals_page.dart';
import '../pages/new_goal_page.dart';
import '../pages/notifications_page.dart';

import '../repositories/api_transaction_repository.dart';
import '../repositories/budget_target_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/statistics_repository.dart';

import '../providers/transaction_provider.dart';
import '../providers/budget_target_provider.dart';
import '../providers/category_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/statistics_provider.dart';

import '../models/app_category.dart';

import 'app_routes.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home.path,
  routes: [
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => TransactionProvider(ApiTransactionRepository())..load(),
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.stats.path,
      name: AppRoutes.stats.name,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => StatisticsProvider(StatisticsRepository())..load(),
        child: const StatsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.budgetGoals.path,
      name: AppRoutes.budgetGoals.name,
      builder: (context, state) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => BudgetTargetProvider(BudgetTargetRepository())..load(),
          ),
          ChangeNotifierProvider(
            create: (_) => CategoryProvider(CategoryRepository())..load(),
          ),
        ],
        child: const BudgetGoalsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.addTransaction.path,
      name: AppRoutes.addTransaction.name,
      builder: (context, state) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => TransactionProvider(ApiTransactionRepository()),
          ),
          ChangeNotifierProvider(
            create: (_) => CategoryProvider(CategoryRepository())..load(),
          ),
        ],
        child: const AddTransactionPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.newGoal.path,
      name: AppRoutes.newGoal.name,
      builder: (context, state) {
        final availableCategories = state.extra as List<AppCategory>;
        return NewGoalPage(availableCategories: availableCategories);
      },
    ),
    GoRoute(
      path: AppRoutes.notifications.path,
      name: AppRoutes.notifications.name,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => NotificationProvider(NotificationRepository())..load(),
        child: const NotificationsPage(),
      ),
    ),
  ],
);