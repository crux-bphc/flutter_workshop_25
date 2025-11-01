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
    final List<DateTime> daysList = List.generate(
      days,
      (i) => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: days - 1 - i)),
    );

    final Map<String, double> result = {
      for (var d in daysList) DateFormat('EEE').format(d): 0.0,
    };

    final expenses = getAllExpenses();
    for (var e in expenses) {
      final eDate = DateTime(e.date.year, e.date.month, e.date.day);
      if (!eDate.isBefore(daysList.first) && !eDate.isAfter(daysList.last)) {
        final label = DateFormat('EEE').format(eDate);
        result[label] = (result[label] ?? 0) + e.amount;
      }
    }

    return result;
  }

  static double getWeeklyAverage({int days = 7}) {
    final weekly = getWeeklyChartData(days: days);
    final total = weekly.values.fold(0.0, (s, v) => s + v);
    return days > 0 ? total / days : 0.0;
  }

  static double getHighestSpending({int days = 7}) {
    final weekly = getWeeklyChartData(days: days);
    if (weekly.isEmpty) return 0.0;
    return weekly.values.reduce((a, b) => a > b ? a : b);
  }
}
