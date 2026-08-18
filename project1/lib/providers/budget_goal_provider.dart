import 'package:flutter/foundation.dart';
import '../models/budget_goal.dart';
import '../repositories/budget_goal_repository.dart';


class BudgetGoalProvider extends ChangeNotifier {
  final BudgetGoalRepository _repository;
  List<BudgetGoal> _goals = [];

  BudgetGoalProvider(this._repository);

  List<BudgetGoal> get goals => _goals;

  Future<void> load() async {
    _goals = await _repository.load();
    notifyListeners();
  }

  Future<void> add(BudgetGoal goal) async {
    _goals.add(goal);
    await _repository.save(_goals);
    notifyListeners();
  }

  Future<void> remove(String category) async {
    _goals.removeWhere((g) => g.category == category);
    await _repository.save(_goals);
    notifyListeners();
  }
}