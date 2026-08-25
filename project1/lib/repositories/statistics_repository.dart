import 'package:dio/dio.dart';
import '../core/api_config.dart';
import '../core/dio_client.dart';
import '../core/constants/ui_strings.dart';
import '../models/statistics_summary.dart';
import '../models/category_statistics.dart';

class StatisticsRepository {
  final Dio _dio = DioClient.instance;
  
  Future<StatisticsSummary> loadSummary({String? month}) async {
    try {
      final response = await _dio.get(
        ApiConfig.statisticsSummary(),
        queryParameters: month != null ? {'month': month} : null,
      );
      return StatisticsSummary.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<CategoryStatistics> loadCategoryStats({String? month}) async {
    try {
      final response = await _dio.get(
        ApiConfig.statisticsCategories(),
        queryParameters: month != null ? {'month': month} : null,
      );
      return CategoryStatistics.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }
}