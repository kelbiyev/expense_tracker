import '../models/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> load();
  Future<Transaction> add(Transaction item, {int? categoryId});
  Future<void> remove(String id);
}