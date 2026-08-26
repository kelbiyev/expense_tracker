import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';

import '../core/constants/ui_colors.dart';
import '../core/constants/ui_strings.dart';
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

  late TabController _tabController;

  String selectedType = TransactionModel.typeExpense;
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedType = _tabController.index == 0
              ? TransactionModel.typeExpense
              : TransactionModel.typeIncome;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    titleController.dispose();
    amountController.dispose();
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
              const Text(UiStrings.chooseCategory, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  Future<void> _save() async {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.replaceAll(',', '.'));

    if (title.isEmpty) {
      _showMessage(UiStrings.emptyTitleAlert);
      return;
    }
    if (amount == null || amount <= 0) {
      _showMessage(UiStrings.falseAmountAlert);
      return;
    }

    final categoryLabel = categoryFor(selectedCategory).label;
    final matchedCategory = context.read<CategoryProvider>().findByDisplayName(categoryLabel);

    if (matchedCategory == null) {
      _showMessage(UiStrings.categoryFindError);
      return;
    }

    final draft = TransactionModel(
      id: 0, // заглушка — сервер сам присвоит id, toJson() его не отправляет
      name: title,
      category: matchedCategory,
      amount: amount,
      date: selectedDate,
      type: selectedType,
    );

    setState(() => _isSaving = true);
    final ok = await context.read<TransactionProvider>().add(draft);

    if (!mounted) return; // await прошёл — виджет мог уже исчезнуть

    setState(() => _isSaving = false);

    if (ok) {
      context.pop();
    } else {
      final message = context.read<TransactionProvider>().errorMessage ?? UiStrings.error;
      _showMessage(message);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final category = categoryFor(selectedCategory);

    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.newTransaction)),
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
                  color: UiColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                labelColor: UiColors.primary,
                unselectedLabelColor: UiColors.cardShadow,
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: const [Tab(text: UiStrings.expenseAz), Tab(text: UiStrings.incomeAz)],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: UiStrings.titleAz, border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: UiStrings.amountAz, border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickCategory,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: UiStrings.categoryAz, border: OutlineInputBorder()),
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
                decoration: const InputDecoration(labelText: UiStrings.dateAz, border: OutlineInputBorder()),
                child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: UiColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: UiColors.white),
                      )
                    : const Text(UiStrings.save, style: TextStyle(color: UiColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}