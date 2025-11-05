import 'package:flutter_workshop_25/models/expense.dart';
import 'package:flutter_workshop_25/services/hive_service.dart';
import 'package:intl/intl.dart';

class ExpenseDataHelper {
  static List<Expense> getAllExpenses() {
    return HiveService.getAllExpenses();
  }

  static double getTotalExpense() {
    final expenses = getAllExpenses();
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  static Map<String, double> getExpensesByDate() {
    final expenses = getAllExpenses();
    final Map<String, double> grouped = {};

    for (var expense in expenses) {
      final formattedDate = DateFormat('dd MMM').format(expense.date);
      grouped[formattedDate] = (grouped[formattedDate] ?? 0) + expense.amount;
    }

    return grouped;
  }

  static List<Map<String, dynamic>> getChartData() {
    final groupedData = getExpensesByDate();
    return groupedData.entries
        .map((e) => {'date': e.key, 'amount': e.value})
        .toList();
  }

  static Map<String, double> getWeeklyChartData({int days = 7}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final Map<String, double> result = {};

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      result[DateFormat('EEE').format(date)] = 0.0;
    }

    final expenses = getAllExpenses();
    final sevenDaysAgo = today.subtract(Duration(days: days - 1));

    for (var expense in expenses) {
      final expenseDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
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

  static double getWeeklyAverage({int days = 7}) {
    final expenses = getAllExpenses();
    final sevenDaysAgo = DateTime.now().subtract(Duration(days: days));

    final recentExpenses = expenses
        .where((e) => e.date.isAfter(sevenDaysAgo))
        .toList();

    if (recentExpenses.isEmpty) return 0.0;

    final total = recentExpenses.fold(0.0, (sum, e) => sum + e.amount);
    return total / days;
  }

  static double getHighestSpending({int days = 7}) {
    final expenses = getAllExpenses();
    final sevenDaysAgo = DateTime.now().subtract(Duration(days: days));

    final recentExpenses = expenses
        .where((e) => e.date.isAfter(sevenDaysAgo))
        .toList();

    if (recentExpenses.isEmpty) return 0.0;

    return recentExpenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }
}
