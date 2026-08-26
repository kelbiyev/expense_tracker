import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;

  TransactionProvider(this._repository);

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _transactions.isEmpty;

  double get income =>
      _transactions.where((t) => !t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get expense =>
      _transactions.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get balance => income - expense;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _repository.load();
      _sortByDateDesc();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> add(TransactionModel transaction) async {
    try {
      final created = await _repository.add(transaction);
      _transactions.add(created);
      _sortByDateDesc();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> remove(int id) async {
    try {
      await _repository.remove(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _sortByDateDesc() {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
  }
}