import 'package:dio/dio.dart';

import '../core/config/dio_client.dart';
import '../models/goal_model.dart';
import 'api_endpoints.dart';

class GoalService {
  final Dio _dio;

  GoalService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<List<GoalModel>> getAll() async {
    final response = await _dio.get(ApiEndpoints.budgetTargets);
    final data = response.data as List? ?? const [];
    return data.map((json) => GoalModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<GoalModel> getById(int id) async {
    final response = await _dio.get(ApiEndpoints.budgetTargetById(id));
    return GoalModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<GoalModel> create({
    required int categoryId,
    required double monthlyLimit,
    required double alertThreshold,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.budgetTargets,
      data: {
        'categoryId': categoryId,
        'monthlyLimit': monthlyLimit,
        'alertThreshold': alertThreshold,
      },
    );
    return GoalModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<void> delete(int id) async {
    await _dio.delete(ApiEndpoints.budgetTargetById(id));
  }
}