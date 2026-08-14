import 'package:flutter/material.dart';
import 'transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  late TabController _tabController;

  final List<String> categories = [
    'Food',
    'Transport',
    'Salary',
    'Cinema',
    'Hobby',
    'Streaming',
    'Subscription',
    'Shopping',
  ];

  String selectedType = 'expense';
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedType = _tabController.index == 0 ? 'expense' : 'income';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kateqoriya seç',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...categories.map((category) {
                return ListTile(
                  leading: Icon(
                    getCategoryIcon(category),
                    color: getCategoryColor(category),
                  ),
                  title: Text(category),
                  onTap: () => Navigator.pop(context, category),
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

  @override
  Widget build(BuildContext context) {
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
                indicatorSize: TabBarIndicatorSize.tab, // ← добавь эту строку
                indicatorPadding: EdgeInsets.all(2),
                indicator: BoxDecoration(
                  color: const Color(0xFF1B5E4F).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                labelColor: const Color(0xFF1B5E4F),
                unselectedLabelColor: Colors.black,
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: const [
                  Tab(text: 'Xərc'),
                  Tab(text: 'Gəlir'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Ad',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Məbləğ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            InkWell(
              onTap: _pickCategory,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Kategoriya',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Icon(
                      getCategoryIcon(selectedCategory),
                      color: getCategoryColor(selectedCategory),
                    ),
                    const SizedBox(width: 8),
                    Text(selectedCategory, style: TextStyle(fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tarix',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Qeyd',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E4F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  String formattedDate =
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                  Transaction newTransaction = Transaction(
                    date: formattedDate,
                    title: titleController.text,
                    category: selectedCategory,
                    amount: double.parse(amountController.text),
                    type: selectedType,
                    note: noteController.text.isEmpty
                        ? null
                        : noteController.text,
                  );
                  Navigator.pop(context, newTransaction);
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
    );
  }
}
