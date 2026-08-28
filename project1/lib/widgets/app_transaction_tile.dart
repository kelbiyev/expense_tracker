import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/transaction_model.dart';

import '../core/constants/ui_categories.dart';
import '../core/utils/formatters.dart';
import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';


class AppTransactionTile extends StatelessWidget {
  const AppTransactionTile({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final localKey = UiCategories.keyForDisplayName(transaction.category.displayName);
    final category = UiCategories.byKey(localKey);
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
                    Text('${UiStrings.category}: ${category.label}'),
                    Text('${UiStrings.amount}: ${transaction.amount}'),
                    Text('${UiStrings.date}: ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
                    Text('${UiStrings.type}: ${transaction.isExpense ? UiStrings.expense : UiStrings.income}'),
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