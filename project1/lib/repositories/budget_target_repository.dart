import 'package:dio/dio.dart';
import '../services/api_endpoints.dart';
import '../core/config/dio_client.dart';
import '../core/constants/ui_strings.dart';
import '../models/goal_model.dart';

class BudgetTargetRepository {
  final Dio _dio = DioClient.instance;

  Future<List<GoalModel>> load() async {
    try {
      final response = await _dio.get(ApiEndpoints.budgetTargets);
      final data = response.data as List? ?? const [];
      return data.map((json) => GoalModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<GoalModel> setTarget({
    required int categoryId,
    required double monthlyLimit,
    required double alertThreshold,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.budgetTargets,
        data: {
          'categoryId': categoryId,
          'monthlyLimit': monthlyLimit,
          'alertThreshold': alertThreshold,
        },
      );
      return GoalModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
    } on DioException catch (e) {
      throw Exception('${UiStrings.saveError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<void> remove(int id) async {
    try {
      await _dio.delete(ApiEndpoints.budgetTargetById(id));
    } on DioException catch (e) {
      throw Exception('${UiStrings.deleteError} ${e.response?.statusCode ?? e.message}');
    }
  }
}