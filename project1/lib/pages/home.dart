import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';

import '../providers/transaction_provider.dart';

import '../routes/app_routes.dart';

import '../widgets/app_error_view.dart';
import '../widgets/app_summary_box.dart';
import '../widgets/app_transaction_tile.dart';

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
            onPressed: () => context.pushNamed(AppRoutes.notification.name),
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
                          context.pushNamed(AppRoutes.goals.name);
                        }),
                        const SizedBox(height: 12),
                        _buildMenuItem(UiStrings.categoryStats, () {
                          context.pushNamed(AppRoutes.statistics.name);
                        }),
                        const SizedBox(height: 12),
                        _buildMenuItem(UiStrings.newTransaction, () {
                          context.pushNamed(AppRoutes.transaction.name);
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

  Widget _buildBody(TransactionProvider provider) {
    if (provider.isLoading && provider.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.isEmpty) {
      return AppErrorView(message: provider.errorMessage!, onRetry: provider.load);
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
                  const Text(UiStrings.balance, style: TextStyle(color: UiColors.white, fontSize: 18)),
                  Text('${formatCurrency(provider.balance)} ${UiStrings.manat}', style: const TextStyle(color: UiColors.white, fontSize: 24)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: AppSummaryBox(label: UiStrings.income, value: provider.income)),
                      const SizedBox(width: 12),
                      Expanded(child: AppSummaryBox(label: UiStrings.expense, value: provider.expense)),
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
                    child: AppTransactionTile(transaction: t),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}