import 'package:flutter/material.dart';
import 'package:flutter_workshop_25/models/expense.dart';
import 'package:flutter_workshop_25/screens/add_expense_screen.dart';
import 'package:flutter_workshop_25/screens/expense_history_screen.dart';
import 'package:flutter_workshop_25/services/hive_service.dart';
import 'package:flutter_workshop_25/theme.dart';
import 'package:flutter_workshop_25/utils/expense_data_helper.dart';
import 'package:flutter_workshop_25/widgets/spending_graph.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _noteController = TextEditingController();
  String _note = '';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    setState(() {
      _note = _noteController.text;
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
      valueListenable: HiveService.getExpenseBox().listenable(),
      builder: (context, Box<Expense> box, _) {
        final totalMonthlyExpense = ExpenseDataHelper.getTotalExpense();
        final weeklyAverage = ExpenseDataHelper.getWeeklyAverage();
        final highestSpending = ExpenseDataHelper.getHighestSpending();
        final weeklyData = ExpenseDataHelper.getWeeklyChartData();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Expense Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpenseHistoryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.3 * 255).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "This Month's Spending",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹${totalMonthlyExpense.toStringAsFixed(0)}",
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_down,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "2.4% less than last month",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.calendar_view_week,
                        title: "Weekly Avg",
                        value: "₹${weeklyAverage.toStringAsFixed(0)}",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.trending_up,
                        title: "Highest Spend",
                        value: "₹${highestSpending.toStringAsFixed(0)}",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weekly Spending Overview",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      SpendingGraph(data: weeklyData),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add a Note",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Note: $_note',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: colorScheme.onSurface),
                          ),
                        ),

                      TextFormField(
                        controller: _noteController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Note",
                          hintText: "Enter note",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: false,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a note";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addNote,
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: colorScheme.primary,
                          ),
                          child: const Text("Add Note"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.25 * 255).round()),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.iconSelected, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
