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

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final months = _lastMonths(3);

      final summaryFutures = months.map((m) => _service.getSummary(month: m)).toList();
      final categoryFutures = months.map((m) => _service.getCategoryStatistics(month: m)).toList();

      final summaries = await Future.wait(summaryFutures);
      final categoryResults = await Future.wait(categoryFutures);

      _summary = _mergeSummaries(summaries);
      _categoryStats = _mergeCategoryStats(categoryResults);
    } catch (e) {
      _errorMessage = ApiException.messageFrom(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> _lastMonths(int count) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final date = DateTime(now.year, now.month - i, 1);
      final month = date.month.toString().padLeft(2, '0');
      return '${date.year}-$month';
    });
  }

  StatisticsSummaryModel _mergeSummaries(List<StatisticsSummaryModel> list) {
    return StatisticsSummaryModel(
      totalBalance: list.fold(0.0, (sum, s) => sum + s.totalBalance),
      totalIncome: list.fold(0.0, (sum, s) => sum + s.totalIncome),
      totalExpense: list.fold(0.0, (sum, s) => sum + s.totalExpense),
    );
  }

  CategoryStatisticsModel _mergeCategoryStats(List<CategoryStatisticsModel> list) {
    final Map<int, CategoryStatisticItem> merged = {};

    for (final stats in list) {
      for (final item in stats.categories) {
        final existing = merged[item.categoryId];
        merged[item.categoryId] = CategoryStatisticItem(
          categoryId: item.categoryId,
          category: item.category,
          categoryName: item.categoryName,
          totalAmount: (existing?.totalAmount ?? 0) + item.totalAmount,
          percentage: 0, 
        );
      }
    }

    final totalExpense = merged.values.fold(0.0, (sum, i) => sum + i.totalAmount);

    final categories = merged.values.map((item) {
      final percentage = totalExpense == 0 ? 0.0 : (item.totalAmount / totalExpense) * 100;
      return CategoryStatisticItem(
        categoryId: item.categoryId,
        category: item.category,
        categoryName: item.categoryName,
        totalAmount: item.totalAmount,
        percentage: percentage,
      );
    }).toList();

    return CategoryStatisticsModel(totalExpense: totalExpense, categories: categories);
  }
}