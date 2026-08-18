import 'package:flutter/material.dart';

import '../models/budget_goal.dart';

import '../core/categories.dart';
import '../core/ui_strings.dart';

class NewGoalPage extends StatefulWidget {
  final List<String> availableCategories;

  const NewGoalPage({super.key, required this.availableCategories});

  @override
  State<NewGoalPage> createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  final TextEditingController limitController = TextEditingController();
  String? selectedCategory;
  double notificationThreshold = 90;

  @override
  void initState() {
    super.initState();
    if (widget.availableCategories.isNotEmpty) {
      selectedCategory = widget.availableCategories.first;
    }
  }

  @override
  void dispose() {
    limitController.dispose();
    super.dispose();
  }

  void _save() {
    final limit = double.tryParse(limitController.text.replaceAll(',', '.'));

    if (selectedCategory == null) {
      _showMessage('Kateqoriya seçin');
      return;
    }
    if (limit == null || limit <= 0) {
      _showMessage('Limit düzgün rəqəm olmalıdır');
      return;
    }

    final newGoal = BudgetGoal(
      category: selectedCategory!,
      monthlyLimit: limit,
      notificationThreshold: notificationThreshold / 100,
    );
    Navigator.pop(context, newGoal);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Hədəf')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Kategoriya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ...widget.availableCategories.map((key) {
                final category = categoryFor(key);
                return _buildCategoryOption(
                  category,
                  selectedCategory == key,
                  () => setState(() => selectedCategory = key),
                );
              }),
              const SizedBox(height: 10),
              TextField(
                controller: limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(prefixText: '₼ ', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              Text('Bildiriş həddi: ${notificationThreshold.round()}%',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Slider(
                value: notificationThreshold,
                min: 50,
                max: 100,
                divisions: 10,
                label: '${notificationThreshold.round()}%',
                onChanged: (value) {
                  setState(() {
                    notificationThreshold = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E4F), padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: _save,
                  child: const Text(AppStrings.save, style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(Category category, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? category.color.withValues(alpha: 0.1) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? category.color : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(category.icon, color: isSelected ? category.color : Colors.grey),
            const SizedBox(width: 12),
            Text(category.label,
                style: TextStyle(
                  color: isSelected ? category.color : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}