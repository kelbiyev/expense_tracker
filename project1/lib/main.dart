import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/app_router.dart';

// import 'repositories/local_transaction_repository.dart';
import 'repositories/api_transaction_repository.dart';
import 'repositories/budget_goal_repository.dart';
import 'repositories/category_repository.dart';

import 'providers/transaction_provider.dart';
import 'providers/budget_goal_provider.dart';
import 'providers/category_provider.dart';

import 'core/constants/ui_strings.dart';

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
          create: (_) => TransactionProvider(ApiTransactionRepository())..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetGoalProvider(BudgetGoalRepository())..load(),
        ),
        ChangeNotifierProvider(
          lazy: false, //lazy true olanda provider yaradilmamishdi , ona gore false olundu
          create: (_) => CategoryProvider(CategoryRepository())..load(),
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