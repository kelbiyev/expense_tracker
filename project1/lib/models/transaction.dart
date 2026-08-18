import 'transaction_type.dart';

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String? note;

  Transaction({
    String? id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    this.note,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String?,
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? 'Other',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      type: TransactionType.fromKey(map['type'] as String?),
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id, 'title': title, 'category': category, 'amount': amount,
    'date': date.toIso8601String(), 'type': type.key, 'note': note,
  };

  bool get isExpense => type == TransactionType.expense;
  bool isInMonth(DateTime month) => date.year == month.year && date.month == month.month;
}