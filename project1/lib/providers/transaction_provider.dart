import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;
  List<Transaction> _transactions = [];

  TransactionProvider(this._repository);

  List<Transaction> get transactions => _transactions;

  double get income => _transactions.where((t) => !t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get expense => _transactions.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get balance => income - expense;

  Future<void> load() async {
    _transactions = await _repository.load();
    notifyListeners();
  }

  Future<void> add(Transaction transaction) async {
    _transactions.add(transaction);
    await _repository.save(_transactions);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _repository.save(_transactions);
    notifyListeners();
  }
}