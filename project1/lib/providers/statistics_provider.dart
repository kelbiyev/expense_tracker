import 'package:flutter/foundation.dart';
import '../models/statistics_summary_model.dart';
import '../models/category_statistics_model.dart';
import '../repositories/statistics_repository.dart';

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepository _repository;

  StatisticsProvider(this._repository);

  StatisticsSummaryModel? _summary;
  CategoryStatisticsModel? _categoryStats;
  bool _isLoading = false;
  String? _errorMessage;

  StatisticsSummaryModel? get summary => _summary;
  CategoryStatisticsModel? get categoryStats => _categoryStats;
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