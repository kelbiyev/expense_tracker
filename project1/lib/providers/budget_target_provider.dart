import 'package:flutter/foundation.dart';
import '../models/budget_target.dart';
import '../repositories/budget_target_repository.dart';

class BudgetTargetProvider extends ChangeNotifier {
  final BudgetTargetRepository _repository;
  List<BudgetTarget> _targets = [];

  BudgetTargetProvider(this._repository);

  List<BudgetTarget> get targets => _targets;

  Future<void> load() async {
    _targets = await _repository.load();
    notifyListeners();
  }

  Future<void> setTarget({
    required int categoryId,
    required double monthlyLimit,
    required double alertThreshold,
  }) async {
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
  }

  Future<void> remove(int id) async {
    await _repository.remove(id);
    _targets.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}