import 'package:flutter/material.dart';

import 'ui_colors.dart';
import 'ui_strings.dart';
import '../utils/txt_normalize.dart';

class UiCategory {
  const UiCategory({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String key;
  final String label;
  final IconData icon;
  final Color color;
}


class UiCategories {
  const UiCategories._();

  static const UiCategory other = UiCategory(
    key: 'Other', 
    label: UiStrings.categoryOther, 
    icon: Icons.category, 
    color: UiColors.categoryOther
  );

  static const List<UiCategory> all = [
    UiCategory(key: 'Food', label: UiStrings.categoryFood, icon: Icons.restaurant, color: UiColors.categoryFood),
    UiCategory(key: 'Transport', label: UiStrings.categoryTransport, icon: Icons.directions_bus, color: UiColors.categoryTransport),
    UiCategory(key: 'Salary', label: UiStrings.categorySalary, icon: Icons.attach_money, color: UiColors.categorySalary),
    UiCategory(key: 'Cinema', label: UiStrings.categoryCinema, icon: Icons.movie, color: UiColors.categoryCinema),
    UiCategory(key: 'Hobby', label: UiStrings.categoryHobby, icon: Icons.sports_esports, color: UiColors.categoryHobby),
    UiCategory(key: 'Streaming', label: UiStrings.categoryStreaming, icon: Icons.tv, color: UiColors.categoryStreaming),
    UiCategory(key: 'Subscription', label: UiStrings.categorySubscription, icon: Icons.subscriptions, color: UiColors.categorySubscription),
    UiCategory(key: 'Shopping', label: UiStrings.categoryShopping, icon: Icons.shopping_bag, color: UiColors.categoryShopping),
    
  ];

  static UiCategory byKey(String key){
    for (final category in all) {
      if (category.key == key) return category;
    }
    return other;
  }

  static String keyForDisplayName(String displayName) {
    final target = normalizeAz(displayName);
    for (final category in all) {
      if (normalizeAz(category.label) == target) return category.key;
    }
    return other.key;
  }

}