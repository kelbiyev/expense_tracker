import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'transaction.dart';
import 'add_transcation_screen.dart';
import 'stats_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 2, 46, 3),
        ),
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
  List<Transaction> transactions = [];
  bool isMenuOpen = false;

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
      body: Stack(
        children: [
          buildHomeContent(),
          AnimatedOpacity(
            opacity: isMenuOpen ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !isMenuOpen,
              child: GestureDetector(
                onTap: () => setState(() => isMenuOpen = false),
                child: Container(color: Colors.black.withValues(alpha: 0.4)),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 130,
            child: IgnorePointer(
              ignoring: !isMenuOpen,
              child: AnimatedSlide(
                offset: isMenuOpen ? Offset.zero : const Offset(0, 0.4),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: AnimatedScale(
                  scale: isMenuOpen ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.bottomRight,
                  child: AnimatedOpacity(
                    opacity: isMenuOpen ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildMenuItem('Büdcə Hədəfləri', Icons.savings, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon...')),
                          );
                        }),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          'Kateqoriya Statistikası',
                          Icons.pie_chart,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StatsScreen(transactions: transactions),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem('Yeni əməliyyat', Icons.add, () async {
                          final result = await Navigator.push<Transaction>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AddTransactionScreen(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              transactions.add(result);
                            });
                            saveTransactions(transactions);
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => isMenuOpen = !isMenuOpen);
        },
        child: Icon(isMenuOpen ? Icons.close : Icons.add),
      ),
    );
  }

  Widget _buildMenuItem(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        setState(() => isMenuOpen = false);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(label, style: const TextStyle(fontSize: 14)),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
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
                    style: const TextStyle(color: Colors.white, fontSize: 24),
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
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction t = transactions[index];
              return Slidable(
                key: Key('${t.title}-${t.date}-$index'),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          transactions.removeAt(index);
                        });
                        saveTransactions(transactions);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ],
                ),
                //MARK: LIST TILE
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: getCategoryColor(
                          t.category,
                        ).withValues(alpha: 0.2),
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
                                if (t.note != null && t.note!.isNotEmpty)
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
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
