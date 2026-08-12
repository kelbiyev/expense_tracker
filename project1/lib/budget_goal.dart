import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetGoal {
  String category;
  double monthlyLimit;
  double notificationThreshold;

  BudgetGoal({
    required this.category,
    required this.monthlyLimit,
    required this.notificationThreshold,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category ,
      'monthlyLimit': monthlyLimit,
      'notificationThreshold': notificationThreshold ,
    };
  }

  factory BudgetGoal.fromMap(Map<String, dynamic> map) {
    return BudgetGoal(
      category: map['category'], 
      monthlyLimit: map['monthlyLimit'], 
      notificationThreshold: map['notificationThreshold']
    );
  }

}

String budgetGoalsToJson(List<BudgetGoal> budgetGoals) {
  List<Map<String, dynamic>> mapsList = budgetGoals
    .map((t) => t.toMap())
    .toList();

  return jsonEncode(mapsList);
}

List<BudgetGoal> budgetGoalsFromJson(String jsonString) {
  List<dynamic> decoded = jsonDecode(jsonString);

  return decoded.map((item) => BudgetGoal.fromMap(item)).toList();
}

Future<void> saveBudgetGoals(List<BudgetGoal> budgetGoals) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('budgetGoals', budgetGoalsToJson(budgetGoals));
}

Future<List<BudgetGoal>> loadBudgetGoals() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('budgetGoals');
  
  if(jsonString == null) return[];

  return budgetGoalsFromJson(jsonString);
}