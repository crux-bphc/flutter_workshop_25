import 'package:flutter/material.dart';
import 'package:flutter_workshop_25/models/expense.dart';
import 'package:flutter_workshop_25/services/hive_service.dart';
import 'package:intl/intl.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];

  ExpenseProvider() {
    _loadExpenses();
  }

  List<Expense> get expenses => _expenses;

  void _loadExpenses() {
    _expenses = HiveService.getAllExpenses();
    notifyListeners();
  }

  void addExpense(Expense expense) {
    HiveService.addExpense(expense);
    _loadExpenses();
  }

  double get totalMonthlyExpense {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get weeklyAverage {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentExpenses = _expenses.where((e) => e.date.isAfter(sevenDaysAgo)).toList();
    if (recentExpenses.isEmpty) return 0.0;
    final total = recentExpenses.fold(0.0, (sum, e) => sum + e.amount);
    return total / 7;
  }

  double get highestSpending {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentExpenses = _expenses.where((e) => e.date.isAfter(sevenDaysAgo)).toList();
    if (recentExpenses.isEmpty) return 0.0;
    return recentExpenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  Map<String, double> getWeeklyChartData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final Map<String, double> result = {};
    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      result[DateFormat('EEE').format(date)] = 0.0;
    }
    final sevenDaysAgo = today.subtract(const Duration(days: 6));
    for (var expense in _expenses) {
      final expenseDate = DateTime(expense.date.year, expense.date.month, expense.date.day);
      if (!expenseDate.isBefore(sevenDaysAgo)) {
        final dayKey = DateFormat('EEE').format(expenseDate);
        if (result.containsKey(dayKey)) {
          result[dayKey] = (result[dayKey] ?? 0) + expense.amount;
        }
      }
    }
    final reversedKeys = result.keys.toList().reversed;
    final finalResult = {for (var k in reversedKeys) k: result[k]!};
    return finalResult;
  }
}
