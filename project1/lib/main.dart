import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/app_router.dart';
import 'core/constants/ui_strings.dart';

import 'services/transaction_service.dart';
import 'services/categories_service.dart';
import 'services/goal_service.dart';

import 'providers/transaction_provider.dart';
import 'providers/categories_provider.dart';
import 'providers/goal_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(TransactionService())..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider(CategoriesService())..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalProvider(GoalService())..load(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: UiStrings.expenseTracker,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 46, 3)),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}