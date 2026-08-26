import '../models/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> load();
  Future<TransactionModel> add(TransactionModel item);
  Future<void> remove(int id);
}