import 'dart:convert';
import 'package:http/http.dart' as http;
import 'transaction_repository.dart';
import '../models/transaction.dart';
import '../models/transaction_api.dart';
import '../models/transaction_request.dart';
import '../models/transaction_type.dart';
import '../core/constants/ui_strings.dart';
import '../core/api_config.dart';
import '../core/categories.dart' as local;

class ApiTransactionRepository implements TransactionRepository {
  @override
  Future<List<Transaction>> load() async {
    final response = await http.get(ApiConfig.transactions());
 
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => ApiTransaction.fromJson(json))
          .map(_toTransaction)
          .toList();
    } else {
       throw Exception('${UiStrings.loadError} ${response.statusCode}');
    }
  }

  @override
  Future<Transaction> add(Transaction item, {int? categoryId}) async {
    if (categoryId == null) {
      throw ArgumentError({UiStrings.apiTransactionRepositoryRequirement});
    }

    final request = TransactionRequest(
      name: item.title,
      amount: item.amount,
      type: item.type == TransactionType.income ? 'GELIR' : 'XERC',
      categoryId: categoryId,
      date: item.date.toIso8601String().split('T').first,
    );

    final response = await http.post(
      ApiConfig.transactions(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return _toTransaction(ApiTransaction.fromJson(json));
    } else {
      throw Exception('${UiStrings.createError} ${response.statusCode}');
    }
  }

  @override
  Future<void> remove(String id) async {
    final response = await http.delete(ApiConfig.transaction(id));

    if (response.statusCode != 200) {
      throw Exception('${UiStrings.deleteError} ${response.statusCode}');
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

    final response = await http.patch(
      ApiConfig.transaction(id),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return _toTransaction(ApiTransaction.fromJson(json));
    } else {
      throw Exception('${UiStrings.reloadError} ${response.statusCode}');
    }
  }

  Transaction _toTransaction(ApiTransaction api) {
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