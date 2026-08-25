import 'package:flutter/material.dart';

import 'routes/app_router.dart';
import 'core/constants/ui_strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: UiStrings.expenseTracker,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 46, 3)),
      ),
      routerConfig: appRouter,
    );
  }
}