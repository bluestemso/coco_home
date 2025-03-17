import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId;
  
  ExpenseService(this._userId);

  // Collection references
  CollectionReference<Map<String, dynamic>> get _expensesCollection =>
      _firestore.collection('users/$_userId/expenses');
      
  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('users/$_userId/categories');

  // Get all expenses
  Stream<List<Expense>> getExpenses() {
    return _expensesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  // Get all categories
  Stream<List<String>> getCategories() {
    return _categoriesCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    });
  }

  // Add new category
  Future<void> addCategory(String name) async {
    // Check if category already exists
    final existing = await _categoriesCollection
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
        
    if (existing.docs.isEmpty) {
      await _categoriesCollection.add({
        'name': name,
        'createdAt': Timestamp.now(),
      });
    }
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
    required String category,
  }) async {
    // First ensure the category exists
    await addCategory(category);
    
    // Then add the expense
    await _expensesCollection.add({
      'description': description,
      'amount': amount,
      'date': Timestamp.now(),
      'paidBy': paidBy,
      'splitWith': splitWith,
      'category': category,
    });
  }

  // Delete expense
  Future<void> deleteExpense(String expenseId) async {
    await _expensesCollection.doc(expenseId).delete();
  }

  // Initialize categories from existing expenses
  Future<void> initializeCategoriesFromExpenses() async {
    final expenses = await _expensesCollection.get();
    for (final doc in expenses.docs) {
      final category = doc.data()['category'] as String?;
      if (category != null) {
        await addCategory(category);
      }
    }
  }
} 