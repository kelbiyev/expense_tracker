import 'package:dio/dio.dart';
import '../services/api_endpoints.dart';
import '../core/config/dio_client.dart';
import '../core/constants/ui_strings.dart';
import '../models/statistics_summary_model.dart';
import '../models/category_statistics_model.dart';

class StatisticsRepository {
  final Dio _dio = DioClient.instance;

  Future<StatisticsSummaryModel> loadSummary({String? month}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.statisticsSummary,
        queryParameters: month != null ? {'month': month} : null,
      );
      return StatisticsSummaryModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<CategoryStatisticsModel> loadCategoryStats({String? month}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.statisticsCategories,
        queryParameters: month != null ? {'month': month} : null,
      );
      return CategoryStatisticsModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }
}