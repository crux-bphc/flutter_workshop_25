import 'package:hive/hive.dart';
import 'package:flutter_workshop_25/models/expense.dart';

class HiveService {
  static const String expenseBoxName = 'expenses';

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExpenseAdapter());
    }
    await Hive.openBox<Expense>(expenseBoxName);
  }

  static Box<Expense> getExpenseBox() {
    return Hive.box<Expense>(expenseBoxName);
  }

  static Future<void> addExpense(Expense expense) async {
    final box = getExpenseBox();
    await box.add(expense);
  }

  static List<Expense> getAllExpenses() {
    final box = getExpenseBox();
    return box.values.toList();
  }

  static Future<void> deleteExpense(int index) async {
    final box = getExpenseBox();
    await box.deleteAt(index);
  }

  static Future<void> clearAll() async {
    final box = getExpenseBox();
    await box.clear();
  }
}
