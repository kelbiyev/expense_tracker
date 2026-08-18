import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'repositories/transaction_repository.dart';
import 'repositories/budget_goal_repository.dart';
import 'providers/transaction_provider.dart';
import 'providers/budget_goal_provider.dart';

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
          create: (_) => TransactionProvider(TransactionRepository())..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetGoalProvider(BudgetGoalRepository())..load(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 46, 3)),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}