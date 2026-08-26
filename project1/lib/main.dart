import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/app_router.dart';
import 'core/constants/ui_strings.dart';

import 'repositories/api_transaction_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/budget_target_repository.dart';

import 'providers/transaction_provider.dart';
import 'providers/category_provider.dart';
import 'providers/budget_target_provider.dart';

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
          create: (_) => CategoryProvider(CategoryRepository())..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetTargetProvider(BudgetTargetRepository())..load(),
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