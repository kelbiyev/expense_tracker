import 'package:dio/dio.dart';
import '../core/constants/ui_strings.dart';
import '../services/api_endpoints.dart';
import '../core/config/dio_client.dart';
import '../models/categories_model.dart';

class CategoryRepository {
  final Dio _dio = DioClient.instance;

  Future<List<CategoriesModel>> load() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final data = response.data as List? ?? const [];
      return data
          .map((json) => CategoriesModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('${UiStrings.categoryLoadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Future<CategoriesModel> add(String name, String displayName) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.categories,
        data: {'name': name, 'displayName': displayName},
      );
      return CategoriesModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
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