import 'package:dio/dio.dart';
import 'transaction_repository.dart';
import '../models/transaction_model.dart';
import '../core/constants/ui_strings.dart';
import '../services/api_endpoints.dart';
import '../core/config/dio_client.dart';

class ApiTransactionRepository implements TransactionRepository {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<TransactionModel>> load() async {
    try {
      final response = await _dio.get(ApiEndpoints.transactions);
      final data = response.data as List? ?? const [];
      return data
          .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  @override
  Future<TransactionModel> add(TransactionModel item) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.transactions,
        data: item.toJson(),
      );
      return TransactionModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
    } on DioException catch (e) {
      throw Exception('${UiStrings.createError} ${e.response?.statusCode ?? e.message}');
    }
  }

  @override
  Future<void> remove(int id) async {
    try {
      await _dio.delete(ApiEndpoints.transactionById(id.toString()));
    } on DioException catch (e) {
      throw Exception('${UiStrings.deleteError} ${e.response?.statusCode ?? e.message}');
    }
  }

  /// Не часть интерфейса — PATCH нужен не всем реализациям.
  Future<TransactionModel> update(TransactionModel item) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.transactionById(item.id.toString()),
        data: item.toJson(),
      );
      return TransactionModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
    } on DioException catch (e) {
      throw Exception('${UiStrings.reloadError} ${e.response?.statusCode ?? e.message}');
    }
  }
}