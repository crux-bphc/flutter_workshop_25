import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_workshop_25/theme.dart';

class ExpenseTile extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime date;

  const ExpenseTile({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.iconSelected,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              currency.format(amount),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
