import 'package:dio/dio.dart';
import 'transaction_repository.dart';
import '../models/transaction.dart';
import '../models/transaction_api.dart';
import '../models/transaction_request.dart';
import '../models/transaction_type.dart';
import '../core/constants/ui_strings.dart';
import '../core/api_config.dart';
import '../core/dio_client.dart';
import '../core/categories.dart' as local;

class ApiTransactionRepository implements TransactionRepository {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<Transaction>> load() async {
    try {
      final response = await _dio.get(ApiConfig.transactions());
      final List<dynamic> data = response.data;
      return data
        .map((json) => TransactionApi.fromJson(json))
        .map(_toTransaction)
        .toList();
    } on DioException catch (e) {
      throw Exception('${UiStrings.loadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  @override
  Future<Transaction> add(Transaction item, {int? categoryId}) async {
    if (categoryId == null) {
      throw ArgumentError(UiStrings.apiTransactionRepositoryRequirement);
    }

    final request = TransactionRequest(
      name: item.title,
      amount: item.amount,
      type: item.type == TransactionType.income ? 'GELIR' : 'XERC',
      categoryId: categoryId,
      date: item.date.toIso8601String().split('T').first,
    );

    try {
      final response = await _dio.post(
        ApiConfig.transactions(),
        data: request.toJson(),
      );
      return _toTransaction(TransactionApi.fromJson(response.data));
    } on DioException catch (e) {
      throw Exception('${UiStrings.createError} ${e.response?.statusCode ?? e.message}');
    }
  }

  @override
  Future<void> remove(String id) async {
    try {
      await _dio.delete(ApiConfig.transaction(id));
    } on DioException catch (e) {
      throw Exception('${UiStrings.deleteError} ${e.response?.statusCode ?? e.message}');
    }
  }

  /// Не часть интерфейса — PATCH нужен не всем реализациям.
  Future<Transaction> update(String id, Transaction item,
      {required int categoryId}) async {
    final request = TransactionRequest(
      name: item.title,
      amount: item.amount,
      type: item.type == TransactionType.income ? 'GELIR' : 'XERC',
      categoryId: categoryId,
      date: item.date.toIso8601String().split('T').first,
    );

    try {
      final response = await _dio.patch(
        ApiConfig.transaction(id),
        data: request.toJson(),
      );
      return _toTransaction(TransactionApi.fromJson(response.data));
    } on DioException catch (e) {
      throw Exception('${UiStrings.reloadError} ${e.response?.statusCode ?? e.message}');
    }
  }

  Transaction _toTransaction(TransactionApi api) {
    return Transaction(
      id: api.id.toString(),
      title: api.name,
      category: local.keyForDisplayName(api.category.displayName),
      amount: api.amount,
      date: api.date,
      type: api.type == 'GELIR'
          ? TransactionType.income
          : TransactionType.expense,
    );
  }
}