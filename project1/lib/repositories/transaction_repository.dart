import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static const String _key = 'transactions';

  Future<List<Transaction>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded.map((e) => Transaction.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('TransactionRepository.load parse xətası: $e');
      return [];
    }
  }

  Future<void> save(List<Transaction> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items.map((t) => t.toMap()).toList()));
  }
}