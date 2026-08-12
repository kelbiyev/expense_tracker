import 'package:flutter/material.dart';
import 'budget_goal.dart';
import 'transaction.dart';

class BudgetGoalsScreen extends StatelessWidget {
  final List<BudgetGoal> budgetGoals;
  final List<Transaction> transactions;
  
  const BudgetGoalsScreen({
    super.key,
    required this.transactions,
    required this.budgetGoals,
  });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Büdcə Hədəfləri')),
      body: SingleChildScrollView(
        
      ),
    );
  }

}