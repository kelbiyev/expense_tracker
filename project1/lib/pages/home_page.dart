import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../models/transaction.dart';
import '../models/budget_goal.dart';

import '../core/categories.dart';
import '../core/formatters.dart';
import '../core/ui_strings.dart';
import '../core/ui_colors.dart';

import '../repositories/transaction_repository.dart';
import '../repositories/budget_goal_repository.dart';

import '../routes/app_routes.dart';

import '../pages/add_transaction_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _transactionRepository = TransactionRepository();
  final _budgetGoalRepository = BudgetGoalRepository();

  List<Transaction> transactions = [];
  List<BudgetGoal> budgetGoals = [];
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedTransactions = await _transactionRepository.load();
    final loadedGoals = await _budgetGoalRepository.load();
    setState(() {
      transactions = loadedTransactions;
      budgetGoals = loadedGoals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Expense Tracker'),
      ),
      body: Stack(
        children: [
          _buildHomeContent(),
          AnimatedOpacity(
            opacity: isMenuOpen ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !isMenuOpen,
              child: GestureDetector(
                onTap: () => setState(() => isMenuOpen = false),
                child: Container(color: AppColors.cardShadow.withValues(alpha: 0.4)),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 130,
            child: IgnorePointer(
              ignoring: !isMenuOpen,
              child: AnimatedSlide(
                offset: isMenuOpen ? Offset.zero : const Offset(0, 0.4),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: AnimatedScale(
                  scale: isMenuOpen ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.bottomRight,
                  child: AnimatedOpacity(
                    opacity: isMenuOpen ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                       
                        _buildMenuItem(AppStrings.budgetGoal, () async {
                          await context.pushNamed(
                            AppRoutes.budgetGoals.name,
                            extra: {
                              'transactions': transactions,
                              'budgetGoals': budgetGoals,
                            },
                          );
                          _loadData();
                        }),
                        const SizedBox(height: 12),

                        
                        _buildMenuItem(AppStrings.categoryStats, () {
                          context.pushNamed(
                            AppRoutes.stats.name,
                            extra: transactions,
                          );
                        }),
                        const SizedBox(height: 12),

                        
                        _buildMenuItem(AppStrings.newTransaction, () async {
                          final result = await context.pushNamed<Transaction>(AppRoutes.addTransaction.name);
                          if (result != null) {
                            setState(() {
                              transactions.add(result);
                            });
                            await _transactionRepository.save(transactions);
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
        child: Icon(isMenuOpen ? Icons.close : Icons.add),
      ),
    );
  }

  Widget _buildMenuItem(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        setState(() => isMenuOpen = false);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: AppColors.cardShadow.withValues(alpha: 0.15), blurRadius: 8),
          ],
        ),
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  double get _balance => _income - _expense;
  double get _income =>
      transactions.where((t) => !t.isExpense).fold(0.0, (sum, t) => sum + t.amount);
  double get _expense =>
      transactions.where((t) => t.isExpense).fold(0.0, (sum, t) => sum + t.amount);

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppStrings.balance, style: TextStyle(color: AppColors.white, fontSize: 18)),
                  Text(
                    '${formatCurrency(_balance)} ₼',
                    style: const TextStyle(color: AppColors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _summaryBox(AppStrings.income, _income)),
                      const SizedBox(width: 12),
                      Expanded(child: _summaryBox(AppStrings.expense, _expense)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(AppStrings.noTransactions, style: TextStyle(color: Colors.grey)),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final t = transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Slidable(
                    key: Key(t.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            setState(() {
                              transactions.removeWhere((item) => item.id == t.id);
                            });
                            await _transactionRepository.save(transactions);
                          },
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ],
                    ),
                    child: _TransactionTile(transaction: t),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _summaryBox(String label, double value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.white70, fontSize: 14)),
          Text(
            '${formatCurrency(value)} ₼',
            style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final category = categoryFor(transaction.category);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.cardShadow.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(category.icon, color: category.color),
        ),
        title: Text(transaction.title),
        subtitle: Text(
          '${category.label} · ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
        ),
        trailing: Text(
          '${formatCurrency(transaction.amount)} ₼',
          style: TextStyle(color: transaction.isExpense ? AppColors.red : AppColors.green, fontSize: 16),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(transaction.title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppStrings.category} ${category.label}'),
                    Text('${AppStrings.amount} ${transaction.amount}'),
                    Text(
                      '${AppStrings.date} ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                    ),
                    Text('${AppStrings.type} ${transaction.type.key}'),
                    if (transaction.note != null && transaction.note!.isNotEmpty)
                      Text('${AppStrings.note} ${transaction.note}'),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.close)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}