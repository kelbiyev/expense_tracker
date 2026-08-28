import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../pages/transaction.dart';
import '../pages/statistics.dart';
import '../pages/goals.dart';
import '../pages/new_goal.dart';
import '../pages/notification.dart';

import '../services/notification_service.dart';
import '../services/statistics_service.dart';

import '../providers/notification_provider.dart';
import '../providers/statistics_provider.dart';

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home.path,
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Səhifə tapılmadı')),
  ),
  routes: [
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => const HomePage(),
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
      path: AppRoutes.goals.path,
      name: AppRoutes.goals.name,
      builder: (context, state) => const GoalsPage(),
    ),
    GoRoute(
      path: AppRoutes.transaction.path,
      name: AppRoutes.transaction.name,
      builder: (context, state) => const TransactionPage(),
    ),
    GoRoute(
      path: AppRoutes.newGoal.path,
      name: AppRoutes.newGoal.name,
      builder: (context, state) => const NewGoalPage(),
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