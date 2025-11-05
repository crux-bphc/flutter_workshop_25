import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingGraph extends StatelessWidget {
  final Map<String, double> data;
  const SpendingGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No spending data yet!"),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48, 
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt() == 0 ? '0' : value >= 1000 ? '${(value ~/ 1000)}K' : value.toInt().toString(),
                    style: const TextStyle(fontSize: 14), 
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final day = data.keys.elementAt(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(day, style: const TextStyle(fontSize: 12)),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          barGroups: data.values.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final amount = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: amount,
                  color: Colors.teal,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
