import 'package:flutter/material.dart';
import 'transaction.dart';
import 'budget_goal.dart';

class NewGoalScreen extends StatefulWidget {
  final List<String> availableCategories;

  const NewGoalScreen({super.key, required this.availableCategories});

  @override
  State<NewGoalScreen> createState() => _NewGoalScreenState();
}

class _NewGoalScreenState extends State<NewGoalScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yeni Hədəf')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Kategoriya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              ...widget.availableCategories.map((category) {
                return _buildCategoryOption(
                  category,
                  selectedCategory == category,
                  () => setState(() => selectedCategory = category),
                );
              }),
              const SizedBox(height: 10),
              TextField(
                controller: limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '₼ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bildiriş həddi: ${notificationThreshold.round()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E4F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: selectedCategory == null
                      ? null
                      : () {
                          BudgetGoal newGoal = BudgetGoal(
                            category: selectedCategory!,
                            monthlyLimit: double.parse(limitController.text),
                            notificationThreshold: notificationThreshold,
                          );
                          Navigator.pop(context, newGoal);
                        },
                  child: const Text(
                    'Yadda saxla',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(
    String category,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? getCategoryColor(category).withValues(alpha: 0.1)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? getCategoryColor(category) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              getCategoryIcon(category),
              color: isSelected ? getCategoryColor(category) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              category,
              style: TextStyle(
                color: isSelected
                    ? getCategoryColor(category)
                    : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
