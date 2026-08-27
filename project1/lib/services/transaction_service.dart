import 'package:dio/dio.dart';

import '../core/config/dio_client.dart';
import '../models/transaction_model.dart';
import 'api_endpoints.dart';

class TransactionService {
  final Dio _dio;

  TransactionService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<List<TransactionModel>> getAll() async {
    final response = await _dio.get(ApiEndpoints.transactions);
    final data = response.data as List? ?? const [];
    return data
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<TransactionModel> getById(int id) async {
    final response = await _dio.get(ApiEndpoints.transactionById(id.toString()));
    return TransactionModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<TransactionModel> create(TransactionModel item) async {
    final response = await _dio.post(ApiEndpoints.transactions, data: item.toJson());
    return TransactionModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<TransactionModel> update(TransactionModel item) async {
    final response = await _dio.patch(
      ApiEndpoints.transactionById(item.id.toString()),
      data: item.toJson(),
    );
    return TransactionModel.fromJson(response.data as Map<String, dynamic>? ?? const {});
  }

  Future<void> delete(int id) async {
    await _dio.delete(ApiEndpoints.transactionById(id.toString()));
  }
}