import 'package:dio/dio.dart';
import '../services/api_endpoints.dart';
import '../core/config/dio_client.dart';
import '../core/constants/ui_strings.dart';
import '../models/statistics_summary.dart';
import '../models/category_statistics.dart';

class StatisticsRepository {
  final Dio _dio = DioClient.instance;

  Future<StatisticsSummary> loadSummary({String? month}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.statisticsSummary,
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
        ApiEndpoints.statisticsCategories,
        queryParameters: month != null ? {'month': month} : null,
      );
      return CategoryStatistics.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }
}