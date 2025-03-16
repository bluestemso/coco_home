import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late final ExpenseService _expenseService;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _paidBy = 'You';

  @override
  void initState() {
    super.initState();
    // TODO: Replace with actual user ID from Firebase Auth
    _expenseService = ExpenseService('user123');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paidBy,
                decoration: const InputDecoration(
                  labelText: 'Paid by',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'You',
                    child: Text('You'),
                  ),
                  DropdownMenuItem(
                    value: 'Alex',
                    child: Text('Alex'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paidBy = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final amount = double.parse(_amountController.text);
                await _expenseService.addExpense(
                  description: _descriptionController.text,
                  amount: amount,
                  paidBy: _paidBy,
                  splitWith: _paidBy == 'You' ? 'Alex' : 'You',
                );
                if (mounted) {
                  Navigator.of(context).pop();
                }
                _descriptionController.clear();
                _amountController.clear();
                _paidBy = 'You';
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddExpenseDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance Summary Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<double>(
              stream: _expenseService.getBalance(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Error loading balance'),
                    ),
                  );
                }

                final balance = snapshot.data ?? 0.0;
                
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          balance >= 0 ? 'You are owed' : 'You owe',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${balance.abs().toStringAsFixed(2)}',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: balance >= 0 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Expenses List
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: _expenseService.getExpenses(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading expenses'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final expenses = snapshot.data!;
                
                if (expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: theme.colorScheme.primary.withValues(alpha: 100),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No expenses yet',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first expense',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 180),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final bool isOwed = expense.paidBy == 'You';
                    
                    return Dismissible(
                      key: Key(expense.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: theme.colorScheme.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      onDismissed: (direction) {
                        _expenseService.deleteExpense(expense.id);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isOwed 
                            ? theme.colorScheme.primary.withValues(alpha: 40)
                            : theme.colorScheme.error.withValues(alpha: 40),
                          child: Icon(
                            isOwed ? Icons.arrow_upward : Icons.arrow_downward,
                            color: isOwed 
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                          ),
                        ),
                        title: Text(expense.description),
                        subtitle: Text(
                          '${isOwed ? 'Owed by' : 'You owe'} ${isOwed ? expense.splitWith : expense.paidBy}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${(expense.amount / 2).toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isOwed 
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error,
                              ),
                            ),
                            Text(
                              _formatDate(expense.date),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
} 