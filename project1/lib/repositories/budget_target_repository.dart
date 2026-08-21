import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../core/ui_strings.dart';
import '../models/budget_target.dart';

class BudgetTargetRepository {
  Future<List<BudgetTarget>> load() async {
    final response = await http.get(ApiConfig.budgetTargets());
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BudgetTarget.fromJson(json)).toList();
    }
    throw Exception('${UiStrings.loadError} ${response.statusCode}');
  }

  Future<BudgetTarget> setTarget({
    required int categoryId,
    required double monthlyLimit,
    required double alertThreshold,
  }) async {
    final response = await http.post(
      ApiConfig.budgetTargets(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'categoryId': categoryId,
        'monthlyLimit': monthlyLimit,
        'alertThreshold': alertThreshold,
      }),
    );
    if (response.statusCode == 200) {
      return BudgetTarget.fromJson(jsonDecode(response.body));
    }
    throw Exception('${UiStrings.saveError} ${response.statusCode}');
  }

  Future<void> remove(int id) async {
    final response = await http.delete(ApiConfig.budgetTarget(id));
    if (response.statusCode != 200) {
      throw Exception('${UiStrings.deleteError} ${response.statusCode}');
    }
  }
}