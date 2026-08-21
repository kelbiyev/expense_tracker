import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../core/ui_strings.dart';
import '../models/statistics_summary.dart';
import '../models/category_statistics.dart';

class StatisticsRepository {
  Future<StatisticsSummary> loadSummary({String? month}) async {
    final response = await http.get(ApiConfig.statisticsSummary(month: month));
    if (response.statusCode == 200) {
      return StatisticsSummary.fromJson(jsonDecode(response.body));
    }
    throw Exception('${UiStrings.loadError} ${response.statusCode}');
  }

  Future<CategoryStatistics> loadCategoryStats({String? month}) async {
    final response =
        await http.get(ApiConfig.statisticsCategories(month: month));
    if (response.statusCode == 200) {
      return CategoryStatistics.fromJson(jsonDecode(response.body));
    }
    throw Exception('${UiStrings.loadError} ${response.statusCode}');
  }
}