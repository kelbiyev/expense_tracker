import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';

import '../core/ui_colors.dart';
import '../core/categories.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  late TabController _tabController;

  TransactionType selectedType = TransactionType.expense;
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedType = _tabController.index == 0 ? TransactionType.expense : TransactionType.income;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickCategory() async {
    final String? picked = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kateqoriya seç', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ...kCategories.map((category) {
                return ListTile(
                  leading: Icon(category.icon, color: category.color),
                  title: Text(category.label),
                  onTap: () => Navigator.pop(context, category.key),
                );
              }),
            ],
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedCategory = picked;
      });
    }
  }

  void _save() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.replaceAll(',', '.'));

    if (title.isEmpty) {
      _showMessage('Ad boş ola bilməz');
      return;
    }
    if (amount == null || amount <= 0) {
      _showMessage('Məbləğ düzgün rəqəm olmalıdır');
      return;
    }

    final newTransaction = Transaction(
      title: title,
      category: selectedCategory,
      amount: amount,
      date: selectedDate,
      type: selectedType,
      note: noteController.text.isEmpty ? null : noteController.text,
    );
    Navigator.pop(context, newTransaction);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final category = categoryFor(selectedCategory);

    return Scaffold(
      appBar: AppBar(title: const Text('New Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(2),
                indicator: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.cardShadow,
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: const [Tab(text: 'Xərc'), Tab(text: 'Gəlir')],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Ad', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Məbləğ', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickCategory,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Kategoriya', border: OutlineInputBorder()),
                child: Row(
                  children: [
                    Icon(category.icon, color: category.color),
                    const SizedBox(width: 8),
                    Text(category.label),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Tarix', border: OutlineInputBorder()),
                child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Qeyd', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _save,
                child: const Text('Yadda saxla', style: TextStyle(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}