import 'package:flutter/foundation.dart';
import '../models/goal_model.dart';
import '../repositories/budget_target_repository.dart';

class BudgetTargetProvider extends ChangeNotifier {
  final BudgetTargetRepository _repository;

  BudgetTargetProvider(this._repository);

  List<GoalModel> _targets = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<GoalModel> get targets => _targets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _targets.isEmpty;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _targets = await _repository.load();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> setTarget({
    required int categoryId,
    required double monthlyLimit,
    required double alertThreshold,
  }) async {
    try {
      final target = await _repository.setTarget(
        categoryId: categoryId,
        monthlyLimit: monthlyLimit,
        alertThreshold: alertThreshold,
      );
      final index = _targets.indexWhere((t) => t.category.id == categoryId);
      if (index != -1) {
        _targets[index] = target;
      } else {
        _targets.add(target);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> remove(int id) async {
    try {
      await _repository.remove(id);
      _targets.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}