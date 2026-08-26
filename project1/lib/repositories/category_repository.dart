import 'package:dio/dio.dart';
import '../core/constants/ui_strings.dart';
import '../services/api_endpoints.dart';
import '../core/config/dio_client.dart';
import '../models/app_category.dart';

class CategoryRepository {
  final Dio _dio = DioClient.instance;

  Future<List<AppCategory>> load() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final List<dynamic> data = response.data as List? ?? const [];
      return data.map((json) => AppCategory.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('${UiStrings.categoryLoadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<AppCategory> add(String name, String displayName) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.categories,
        data: {'name': name, 'displayName': displayName},
      );
      return AppCategory.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${UiStrings.categoryAddError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<void> remove(int id) async {
    try {
      await _dio.delete(ApiEndpoints.categoryById(id));
    } on DioException catch (e) {
      throw Exception('${UiStrings.categoryDeleteError} ${e.response?.statusCode ?? e.message}');
    }
  }
}