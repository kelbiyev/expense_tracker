import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  String title;
  String category;
  double amount;
  String date;
  String type;
  String? note;

  Transaction({
    required this.date,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'category': category,
      'amount': amount,
      'type': type,
      'note': note,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      date: map['date'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      type: map['type'],
      note: map['note'],
    );
  }
}

Map<String, IconData> categoryIcons = {
  'Food': Icons.restaurant,
  'Transport': Icons.directions_bus,
  'Salary': Icons.attach_money,
  'Cinema': Icons.movie,
  'Hobby': Icons.sports_esports,
  'Streaming': Icons.tv,
  'Subscription': Icons.subscriptions,
  'Shopping': Icons.shopping_bag,
};

Map<String, Color> categoryColors = {
  'Food': Colors.orange,
  'Transport': Colors.blue,
  'Salary': Colors.green,
  'Cinema': Colors.purple,
  'Hobby': Colors.pink,
  'Streaming': Colors.red,
  'Subscription': Colors.teal,
  'Shopping': Colors.brown,
};

//MARK: FUNCTIONS
String formatCurrency(double value) {
  final formatter = NumberFormat('#,##0.00');
  return formatter.format(value);
}

double calculateTotal(List<Transaction> transactions) {
  double total = 0;
  for (int i = 0; i < transactions.length; i++) {
    Transaction t = transactions[i];
    if (t.type == 'expense') {
      total = total - t.amount;
    } else {
      total = total + t.amount;
    }
  }

  return total;
}

double calculateExpense(List<Transaction> transactions) {
  double expense = 0;
  for (int i = 0; i < transactions.length; i++) {
    if (transactions[i].type == 'expense') {
      expense = expense + transactions[i].amount;
    }
  }
  return expense;
}

double calculateIncome(List<Transaction> transactions) {
  double income = 0;
  for (int i = 0; i < transactions.length; i++) {
    if (transactions[i].type == 'income') {
      income = income + transactions[i].amount;
    }
  }
  return income;
}

IconData getCategoryIcon(String category) {
  return categoryIcons[category] ?? Icons.category;
}

Color getCategoryColor(String category) {
  return categoryColors[category] ?? Colors.grey;
}

//MARK: CHARTS
Map<String, double> calculateCategoryTotals(List<Transaction> transactions) {
  Map<String, double> categoryTotals = {};

  for (int i = 0; i < transactions.length; i++) {
    Transaction t = transactions[i];
    if (t.type == 'expense') {
      if (categoryTotals.containsKey(t.category)) {
        categoryTotals[t.category] = categoryTotals[t.category]! + t.amount;
      } else {
        categoryTotals[t.category] = t.amount;
      }
    }
  }

  return categoryTotals;
}

List<PieChartSectionData> buildSections(Map<String, double> categoryTotals) {
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    const Color.fromARGB(255, 73, 97, 19),
  ];
  List<PieChartSectionData> sections = [];
  int colorIndex = 0;

  categoryTotals.forEach((category, total) {
    sections.add(
      PieChartSectionData(
        value: total,
        title: category,
        color: colors[colorIndex % colors.length],
        radius: 60,
      ),
    );
    colorIndex++;
  });

  return sections;
}

//MARK: JSON
String transactionsToJson(List<Transaction> transactions) {
  List<Map<String, dynamic>> mapsList = transactions
      .map((t) => t.toMap())
      .toList();

  return jsonEncode(mapsList);
}

List<Transaction> transactionsFromJson(String jsonString) {
  List<dynamic> decoded = jsonDecode(jsonString);

  return decoded.map((item) => Transaction.fromMap(item)).toList();
}

Future<void> saveTransactions(List<Transaction> transactions) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('transactions', transactionsToJson(transactions));
}

Future<List<Transaction>> loadTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('transactions');
  if (jsonString == null) {
    return [];
  }

  return transactionsFromJson(jsonString);
}
