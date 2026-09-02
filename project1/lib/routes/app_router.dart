import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../pages/transaction.dart';
import '../pages/statistics.dart';
import '../pages/goals.dart';
import '../pages/new_goal.dart';
import '../pages/notification.dart';

import '../services/transaction_service.dart';
import '../services/categories_service.dart';
import '../services/goal_service.dart';
import '../services/notification_service.dart';
import '../services/statistics_service.dart';

import '../providers/transaction_provider.dart';
import '../providers/categories_provider.dart';
import '../providers/goal_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/statistics_provider.dart';

import 'app_routes.dart';

/// Каждый провайдер вешается только там, где он реально нужен —
/// не на все route разом. Единственный, кому требуется ОБЩИЙ (не
/// пересоздаваемый) экземпляр — TransactionProvider между Home и
/// Transaction: иначе новая операция не долетит до списка на Home.
/// Поэтому только они внутри ShellRoute. CategoriesProvider и
/// GoalProvider нигде не обязаны быть общим экземпляром между
/// страницами (ни одна из них не полагается на то, что другая
/// страница уже успела что-то в них изменить) — у каждой странице
/// свой собственный, точечно навешанный.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home.path,
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Səhifə tapılmadı')),
  ),
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ChangeNotifierProvider(
          create: (_) => TransactionProvider(TransactionService())..load(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.home.path,
          name: AppRoutes.home.name,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.transaction.path,
          name: AppRoutes.transaction.name,
          // CategoriesProvider нужен только здесь (поиск categoryId по
          // имени) — TransactionProvider уже доступен из ShellRoute выше.
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => CategoriesProvider(CategoriesService())..load(),
            child: const TransactionPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.goals.path,
      name: AppRoutes.goals.name,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => GoalProvider(GoalService())..load(),
        child: const GoalsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.newGoal.path,
      name: AppRoutes.newGoal.name,
      builder: (context, state) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CategoriesProvider(CategoriesService())..load(),
          ),
          ChangeNotifierProvider(
            create: (_) => GoalProvider(GoalService())..load(),
          ),
        ],
        child: const NewGoalPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.statistics.path,
      name: AppRoutes.statistics.name,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => StatisticsProvider(StatisticsService())..load(),
        child: const StatisticsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.notification.path,
      name: AppRoutes.notification.name,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => NotificationProvider(NotificationService())..load(),
        child: const NotificationPage(),
      ),
    ),
  ],
);