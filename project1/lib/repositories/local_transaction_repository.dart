import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:project1/core/ui_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'transaction_repository.dart';

import '../models/transaction.dart';

class LocalTransactionRepository implements TransactionRepository {
  static const String _key = 'transactions';

  @override
  Future<List<Transaction>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((e) => Transaction.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('${UiStrings.transactionLoadParseError} $e');
      return [];
    }
  }

  Future<void> _saveAll(List<Transaction> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(items.map((t) => t.toMap()).toList()));
  }

  @override
  Future<Transaction> add(Transaction item, {int? categoryId}) async {
    final current = await load();
    current.add(item);
    await _saveAll(current);
    return item;
  }

  @override
  Future<void> remove(String id) async {
    final current = await load();
    current.removeWhere((t) => t.id == id);
    await _saveAll(current);
  }
}