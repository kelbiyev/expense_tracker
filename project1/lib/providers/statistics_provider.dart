import 'package:flutter/foundation.dart';
import '../models/statistics_summary.dart';
import '../models/category_statistics.dart';
import '../repositories/statistics_repository.dart';

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepository _repository;

  StatisticsProvider(this._repository);

  StatisticsSummary? _summary;
  CategoryStatistics? _categoryStats;

  StatisticsSummary? get summary => _summary;
  CategoryStatistics? get categoryStats => _categoryStats;

  Future<void> load({String? month}) async {
    _summary = await _repository.loadSummary(month: month);
    _categoryStats = await _repository.loadCategoryStats(month: month);
    notifyListeners();
  }
}