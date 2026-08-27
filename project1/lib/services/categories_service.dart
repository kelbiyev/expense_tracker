import 'package:dio/dio.dart';

import '../core/config/dio_client.dart';
import '../models/categories_model.dart';
import 'api_endpoints.dart';

class CategoriesService {
  final Dio _dio;

  CategoriesService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<List<CategoriesModel>> getAll() async {
    final response = await _dio.get(ApiEndpoints.categories);
    final data = response.data as List? ?? const [];
    return data.map((json) => CategoriesModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<CategoriesModel> getById(int id) async {
    final response = await _dio.get(ApiEndpoints.categoryById(id));
    return CategoriesModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<CategoriesModel> create(String name, String displayName) async {
    final response = await _dio.post(
      ApiEndpoints.categories,
      data: {'name': name, 'displayName': displayName},
    );
    return CategoriesModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<void> delete(int id) async {
    await _dio.delete(ApiEndpoints.categoryById(id));
  }
}