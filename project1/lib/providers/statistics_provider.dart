import 'package:flutter/foundation.dart';
import '../models/statistics_summary.dart';
import '../models/category_statistics.dart';
import '../repositories/statistics_repository.dart';

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepository _repository;

  StatisticsProvider(this._repository);

  StatisticsSummary? _summary;
  CategoryStatistics? _categoryStats;
  bool _isLoading = false;
  String? _errorMessage;

  StatisticsSummary? get summary => _summary;
  CategoryStatistics? get categoryStats => _categoryStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> load({String? month}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final summaryFuture = _repository.loadSummary(month: month);
      final categoryStatsFuture = _repository.loadCategoryStats(month: month);
      _summary = await summaryFuture;
      _categoryStats = await categoryStatsFuture;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}