import 'package:flutter/material.dart';
import 'package:flutter_workshop_25/theme.dart';
import 'package:flutter_workshop_25/widgets/spending_graph.dart';
import 'package:flutter_workshop_25/utils/expense_data_helper.dart';
import 'package:flutter_workshop_25/screens/add_expense_screen.dart';
import 'package:flutter_workshop_25/screens/expense_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalMonthlyExpense = 0;
  double weeklyAverage = 0;
  double highestSpending = 0;
  Map<String, double> weeklyData = {};

  @override
  void initState() {
    super.initState();
    _loadExpenseData();
  }

  void _loadExpenseData() {
    setState(() {
      totalMonthlyExpense = ExpenseDataHelper.getTotalExpense();
      weeklyAverage = ExpenseDataHelper.getWeeklyAverage();
      highestSpending = ExpenseDataHelper.getHighestSpending();
      weeklyData = ExpenseDataHelper.getWeeklyChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    "This Month’s Spending",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${totalMonthlyExpense.toStringAsFixed(0)}",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.textSecondary,
                        ),
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
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              )
              .then((_) => _loadExpenseData());
        },
        child: const Icon(Icons.add),
      ),
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
