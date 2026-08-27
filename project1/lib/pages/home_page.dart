import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';

import '../core/categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/transaction_provider.dart';

import '../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(UiStrings.expenseTracker),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.pushNamed(AppRoutes.notifications.name),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(transactionProvider),
          AnimatedOpacity(
            opacity: isMenuOpen ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !isMenuOpen,
              child: GestureDetector(
                onTap: () => setState(() => isMenuOpen = false),
                child: Container(color: UiColors.cardShadow.withValues(alpha: 0.4)),
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
                        _buildMenuItem(UiStrings.budgetGoal, () {
                          context.pushNamed(AppRoutes.budgetGoals.name);
                        }),
                        const SizedBox(height: 12),
                        _buildMenuItem(UiStrings.categoryStats, () {
                          context.pushNamed(AppRoutes.stats.name);
                        }),
                        const SizedBox(height: 12),
                        _buildMenuItem(UiStrings.newTransaction, () {
                          // TransactionProvider теперь общий (создан в
                          // main.dart) — AddTransactionPage пишет в тот же
                          // самый экземпляр, notifyListeners() сам долетит
                          // сюда через context.watch. Ручной перезапрос
                          // после push больше не нужен.
                          context.pushNamed(AppRoutes.addTransaction.name);
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
          color: UiColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: UiColors.cardShadow.withValues(alpha: 0.15), blurRadius: 8)],
        ),
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  // 4 состояния: loading → error → empty → success.
  Widget _buildBody(TransactionProvider provider) {
    if (provider.isLoading && provider.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.isEmpty) {
      return _ErrorView(
        message: provider.errorMessage!,
        onRetry: provider.load,
      );
    }

    return _buildHomeContent(provider);
  }

  Widget _buildHomeContent(TransactionProvider provider) {
    final transactions = provider.transactions;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: UiColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: UiColors.cardShadow.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(UiStrings.balanceAz, style: TextStyle(color: UiColors.white, fontSize: 18)),
                  Text('${formatCurrency(provider.balance)} ${UiStrings.manat}', style: const TextStyle(color: UiColors.white, fontSize: 24)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _summaryBox(UiStrings.incomeAz, provider.income)),
                      const SizedBox(width: 12),
                      Expanded(child: _summaryBox(UiStrings.expenseAz, provider.expense)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(UiStrings.noTransactions, style: TextStyle(color: UiColors.grey)),
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
                    key: Key(t.id.toString()),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            context.read<TransactionProvider>().remove(t.id);
                          },
                          backgroundColor: UiColors.red,
                          foregroundColor: UiColors.white,
                          icon: Icons.delete,
                          label: UiStrings.delete,
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
      decoration: BoxDecoration(color: UiColors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: UiColors.white70, fontSize: 14)),
          Text('${formatCurrency(value)} ${UiStrings.manat}', style: const TextStyle(color: UiColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text(UiStrings.retry)),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final localKey = keyForDisplayName(transaction.category.displayName);
    final category = categoryFor(localKey);
    return Container(
      decoration: BoxDecoration(
        color: UiColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: UiColors.cardShadow.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: category.color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
          child: Icon(category.icon, color: category.color),
        ),
        title: Text(transaction.name),
        subtitle: Text('${category.label} · ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
        trailing: Text(
          '${formatCurrency(transaction.amount)} ${UiStrings.manat}',
          style: TextStyle(color: transaction.isExpense ? UiColors.red : UiColors.green, fontSize: 16),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(transaction.name),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${UiStrings.category} ${category.label}'),
                    Text('${UiStrings.amount} ${transaction.amount}'),
                    Text('${UiStrings.date} ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
                    Text('${UiStrings.type} ${transaction.type}'),
                  ],
                ),
                actions: [TextButton(onPressed: () => context.pop(), child: const Text(UiStrings.close))],
              );
            },
          );
        },
      ),
    );
  }
}