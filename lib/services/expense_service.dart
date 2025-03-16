import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId;
  
  ExpenseService(this._userId);

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _expensesCollection =>
      _firestore.collection('users/$_userId/expenses');

  // Get all expenses
  Stream<List<Expense>> getExpenses() {
    return _expensesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  // Get balance
  Stream<double> getBalance() {
    return getExpenses().map((expenses) {
      return expenses.fold<double>(0, (balance, expense) {
        if (expense.paidBy == 'You') {
          return balance + (expense.amount / 2);
        } else {
          return balance - (expense.amount / 2);
        }
      });
    });
  }

  // Add new expense
  Future<void> addExpense({
    required String description,
    required double amount,
    required String paidBy,
    required String splitWith,
  }) async {
    await _expensesCollection.add({
      'description': description,
      'amount': amount,
      'date': Timestamp.now(),
      'paidBy': paidBy,
      'splitWith': splitWith,
    });
  }

  // Delete expense
  Future<void> deleteExpense(String expenseId) async {
    await _expensesCollection.doc(expenseId).delete();
  }
} 