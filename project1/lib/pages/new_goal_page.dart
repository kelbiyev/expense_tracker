import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/app_category.dart';

import '../core/categories.dart';
import '../core/constants/ui_strings.dart';
import '../core/constants/ui_colors.dart';


class NewGoalPage extends StatefulWidget {
  final List<AppCategory> availableCategories;

  const NewGoalPage({super.key, required this.availableCategories});

  @override
  State<NewGoalPage> createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  final TextEditingController limitController = TextEditingController();
  AppCategory? selectedCategory;
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
      _showMessage(UiStrings.chooseCategory);
      return;
    }
    if (limit == null || limit <= 0) {
      _showMessage(UiStrings.falseLimitAlert);
      return;
    }
    context.pop((selectedCategory!.id, limit, notificationThreshold));
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.newGoal)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(UiStrings.categoryAz, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ...widget.availableCategories.map((category) {
                return _buildCategoryOption(
                  category,
                  selectedCategory?.id == category.id,
                  () => setState(() => selectedCategory = category),
                );
              }),
              const SizedBox(height: 10),
              TextField(
                controller: limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(prefixText: '${UiStrings.manat} ', border: OutlineInputBorder()),
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
                  style: ElevatedButton.styleFrom(backgroundColor: UiColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: _save,
                  child: const Text(UiStrings.save, style: TextStyle(color: UiColors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(AppCategory appCategory, bool isSelected, VoidCallback onTap) {
    final localKey = keyForDisplayName(appCategory.displayName);
    final visual = categoryFor(localKey);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? visual.color.withValues(alpha: 0.1) : UiColors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? visual.color : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(visual.icon, color: isSelected ? visual.color : UiColors.grey),
            const SizedBox(width: 12),
            Text(visual.label,
                style: TextStyle(
                  color: isSelected ? visual.color : UiColors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}