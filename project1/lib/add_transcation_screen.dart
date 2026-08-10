import 'package:flutter/material.dart';
import 'transaction.dart';


class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
  
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}


class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();



  final List<String> categories = [
    'Food',
    'Transport',
    'Salary',
    'Cinema',
    'Hobby',
    'Streaming',
    'Subscription',
    'Shopping'
  ];
 
  String selectedType = 'expense';
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
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
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'expense', label: Text('Expense')),
                ButtonSegment(value: 'income', label: Text('Income')),
              ],
              selected: {selectedType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  selectedType = newSelection.first;
                });
              },
              multiSelectionEnabled: false,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder()
              ),
            ),
            
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            TextButton(
              onPressed: _pickDate, 
              child: Text('Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}')
            ),

            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String formattedDate = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                Transaction newTransaction = Transaction(
                  date: formattedDate,
                  title: titleController.text,
                  category: selectedCategory,
                  amount: double.parse(amountController.text),
                  type: selectedType,
                  note: noteController.text.isEmpty ? null: noteController.text,
                );
                Navigator.pop(context, newTransaction);
              }, 
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}