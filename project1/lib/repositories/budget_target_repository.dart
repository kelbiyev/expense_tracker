import 'package:dio/dio.dart';
import '../core/api_config.dart';
import '../core/dio_client.dart';
import '../core/constants/ui_strings.dart';
import '../models/budget_target.dart';

class BudgetTargetRepository {
  final Dio _dio = DioClient.instance;

  Future<List<BudgetTarget>> load() async {
    try {
      final response = await _dio.get(ApiConfig.budgetTargets());
      final List<dynamic> data = response.data;
      return data.map((json) => BudgetTarget.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<BudgetTarget> setTarget({
    required int categoryId,
    required double monthlyLimit,
    required double alertThreshold,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.budgetTargets(),
        data: {
          'categoryId': categoryId,
          'monthlyLimit': monthlyLimit,
          'alertThreshold': alertThreshold,
        },
      );
      return BudgetTarget.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${UiStrings.saveError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<void> remove(int id) async {
    try {
      await _dio.delete(ApiConfig.budgetTarget(id));
    } on DioException catch (e) {
      throw Exception('${UiStrings.deleteError} ${e.response?.statusCode ?? e.message}');
    }
  }
}