import 'package:flutter/material.dart';
import 'utils/txt_normalize.dart';

class Category {
  const Category({required this.key, required this.label, required this.icon, required this.color});
  final String key;
  final String label;
  final IconData icon;
  final Color color;
}

const List<Category> kCategories = [
  Category(key: 'Food', label: 'Yemək', icon: Icons.restaurant, color: Color(0xFFFF9800)),
  Category(key: 'Transport', label: 'Nəqliyyat', icon: Icons.directions_bus, color: Color(0xFF2196F3)),
  Category(key: 'Salary', label: 'Maaş', icon: Icons.attach_money, color: Color(0xFF4CAF50)),
  Category(key: 'Cinema', label: 'Kino', icon: Icons.movie, color: Color(0xFF9C27B0)),
  Category(key: 'Hobby', label: 'Hobbi', icon: Icons.sports_esports, color: Color(0xFFE91E63)),
  Category(key: 'Streaming', label: 'Striminq', icon: Icons.tv, color: Color(0xFFF44336)),
  Category(key: 'Subscription', label: 'Abunəlik', icon: Icons.subscriptions, color: Color(0xFF009688)),
  Category(key: 'Shopping', label: 'Alış-veriş', icon: Icons.shopping_bag, color: Color(0xFF795548)),
];

Category categoryFor(String key) => kCategories.firstWhere(
  (c) => c.key == key,
  orElse: () => const Category(key: 'Other', label: 'Digər', icon: Icons.category, color: Color(0xFF9E9E9E)),
);

String keyForDisplayName(String displayName) {
  final target = normalizeAz(displayName);
  final match = kCategories.where((c) => normalizeAz(c.label) == target);
  return match.isEmpty ? 'Other' : match.first.key;
}