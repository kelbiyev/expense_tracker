import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:project1/core/constants/ui_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget_goal.dart';

class BudgetGoalRepository {
  static const String _key = 'budgetGoals';

  Future<List<BudgetGoal>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((e) => BudgetGoal.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('${UiStrings.budgetGoalLoadParseError} $e');
      return [];
    }
  }

  Future<void> save(List<BudgetGoal> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((g) => g.toMap()).toList()));
  }
}