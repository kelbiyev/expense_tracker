import 'package:dio/dio.dart';

import '../core/config/dio_client.dart';
import '../models/statistics_summary_model.dart';
import '../models/category_statistics_model.dart';
import 'api_endpoints.dart';

class StatisticsService {
  final Dio _dio;

  StatisticsService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<StatisticsSummaryModel> getSummary({String? month}) async {
    final response = await _dio.get(
      ApiEndpoints.statisticsSummary,
      queryParameters: month != null ? {'month': month} : null,
    );
    return StatisticsSummaryModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<CategoryStatisticsModel> getCategoryStatistics({String? month}) async {
    final response = await _dio.get(
      ApiEndpoints.statisticsCategories,
      queryParameters: month != null ? {'month': month} : null,
    );
    return CategoryStatisticsModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }
}