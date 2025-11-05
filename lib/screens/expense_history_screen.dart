import 'package:flutter/material.dart';
import 'package:flutter_workshop_25/models/expense.dart';
import 'package:flutter_workshop_25/services/hive_service.dart';
import 'package:flutter_workshop_25/widgets/expense_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseHistoryScreen extends StatelessWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense History')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: ValueListenableBuilder(
          valueListenable: HiveService.getExpenseBox().listenable(),
          builder: (context, Box<Expense> box, _) {
            if (box.values.isEmpty) {
              return const Center(child: Text('No expenses yet.'));
            }

            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                final expense = box.getAt(index) as Expense;
                return ExpenseTile(
                  title: expense.title,
                  amount: expense.amount,
                  date: expense.date,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
