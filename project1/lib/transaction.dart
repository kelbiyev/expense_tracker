import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  String title;
  String category;
  double amount;
  String date;

  Transaction(this.date, this.title, this.category, this.amount);


  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'category': category,
      'amount': amount,
    };
  }


  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      map['date'], 
      map['title'], 
      map['category'], 
      map['amount'],
    );
  }
}

//MARK: FUNCTIONS


double calculateTotal(List<Transaction> transactions) {
  double total = 0;
  for (int i = 0; i< transactions.length; i++) {
    total = total + transactions[i].amount;
  }

  return total;
}


double calculateExpense(List<Transaction> transactions) {
  double expense = 0;
  for(int i = 0; i< transactions.length; i++) {
    if(transactions[i].amount < 0){
      expense = expense + transactions[i].amount;
    }
  }
  return expense.abs();
}

double calculateIncome(List<Transaction> transactions) {
  double income = 0;
  for(int i = 0; i< transactions.length; i++) {
    if(transactions[i].amount > 0){
      income = income + transactions[i].amount;
    }
  }
  return income;
}

//MARK: CHARTS

Map<String, double> calculateCategoryTotals(List<Transaction> transactions) {
  Map<String, double> categoryTotals = {};

  for(int i = 0;i < transactions.length; i++) {
    Transaction t = transactions[i];
    if(t.amount < 0) {
      if(categoryTotals.containsKey(t.category)) {
        categoryTotals[t.category] = categoryTotals[t.category]! + t.amount.abs();
      } else {
        categoryTotals[t.category] = t.amount.abs();
      }
    }
  }

  return categoryTotals;
}


List<PieChartSectionData> buildSections(Map<String, double> categoryTotals) {
  List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.orange];
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
  List<Map<String, dynamic>> mapsList = transactions.map((t) => t.toMap()).toList();
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
  if(jsonString == null) {
    return [];
  }

  return transactionsFromJson(jsonString);
}
