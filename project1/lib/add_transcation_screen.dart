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



  final List<String> categories = [
    'Food',
    'Transport',
    'Salary',
    'Cinema',
    'Hobby',
    'Streaming',
    'Subscription',
  ];

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
                border: OutlineInputBorder(),
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
            ElevatedButton(
              onPressed: () {
                String formattedDate = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                Transaction newTransaction = Transaction(
                  formattedDate,
                  titleController.text,
                  selectedCategory,
                  double.parse(amountController.text),
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