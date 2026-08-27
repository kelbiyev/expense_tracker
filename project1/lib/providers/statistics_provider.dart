import 'package:flutter/foundation.dart';
import '../core/config/api_exception.dart';
import '../models/statistics_summary_model.dart';
import '../models/category_statistics_model.dart';
import '../services/statistics_service.dart';

class StatisticsProvider extends ChangeNotifier {
  final StatisticsService _service;

  StatisticsProvider(this._service);

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
      final summaryFuture = _service.getSummary(month: month);
      final categoryStatsFuture = _service.getCategoryStatistics(month: month);
      _summary = await summaryFuture;
      _categoryStats = await categoryStatsFuture;
    } catch (e) {
      _errorMessage = ApiException.messageFrom(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}