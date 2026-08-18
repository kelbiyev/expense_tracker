import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final formatter = NumberFormat('#,##0.00');
  return formatter.format(value);
}