import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'transaction.dart';
import 'add_transcation_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 46, 3)),
      ),
      home: const MyHomePage(title: 'Expense Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedIndex = 0;
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loaded = await loadTransactions();
    setState(() {
      transactions = loaded;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: selectedIndex == 0 ? buildHomeContent() : buildStatsContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home) , label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Stats'),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.push<Transaction>(
            context, 
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
          if (result !=null) {
            setState(() {
              transactions.add(result);
            });
            saveTransactions(transactions);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }


  //MARK: Home Screen

  Widget buildHomeContent() {

    double balance = calculateTotal(transactions);
    double expense = calculateExpense(transactions);
    double income = calculateIncome(transactions);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E4F),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Balance', 
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '${formatCurrency(balance)} ₼',
                    style: const TextStyle(color: Colors.white , fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Income', 
                                style: TextStyle(
                                  color: Colors.white70, 
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${formatCurrency(income)} ₼',
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expense',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${formatCurrency(expense)} ₼',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction t = transactions[index];
              return Dismissible(
                key: Key('${t.title}-${t.date}-$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete,color: Colors.white),
                ),
                onDismissed: (direction) {
                  setState(() {
                    transactions.removeAt(index);
                  });
                  saveTransactions(transactions);
                },
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: getCategoryColor(t.category).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      getCategoryIcon(t.category),
                      color: getCategoryColor(t.category),
                    ),
                  ),
                  title: Text(t.title),
                  subtitle: Text('${t.category} · ${t.date}'),
                  trailing: Text(
                    '${formatCurrency(t.amount)} ₼',
                    style: TextStyle(
                    color: t.type == 'expense' ? Colors.red : Colors.green,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: Text(t.title),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${t.category}'),
                              Text('Amount: ${t.amount}'),
                              Text('Date: ${t.date}'),
                              Text('Type: ${t.type}'),
                              if(t.note != null && t.note!.isNotEmpty)
                                Text('Note: ${t.note}'),                              
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), 
                              child: const Text('Close'),
                            ),
                          ],
                        ); 
                      });
                  },
                ), 
              );
            },
          ),
        ],
      ),
    );
  }

  //MARK: Stats

  Widget buildStatsContent() {
    final categoryTotals = calculateCategoryTotals(transactions);
    return Center(
      child: SizedBox(
        height: 300, 
        child: PieChart(
          PieChartData(
            sections: buildSections(categoryTotals),
          )
        ),
      ),
    );
  }
}
