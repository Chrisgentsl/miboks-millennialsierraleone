import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sales_model.dart';
import 'package:intl/intl.dart';

class SalesChartWidget extends StatelessWidget {
  final List<SaleModel> sales;
  final Color color;
  final String title;

  const SalesChartWidget({
    super.key,
    required this.sales,
    required this.color,
    required this.title,
  });

  List<FlSpot> _generateSpots() {
    // Group sales by date
    final Map<DateTime, double> dailyTotals = {};
    
    for (var sale in sales) {
      final date = DateTime(
        sale.timestamp.year,
        sale.timestamp.month,
        sale.timestamp.day,
      );
      dailyTotals[date] = (dailyTotals[date] ?? 0) + sale.totalAmount;
    }

    // Convert to list and sort by date
    final sortedEntries = dailyTotals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Create spots
    return List.generate(sortedEntries.length, (index) {
      return FlSpot(index.toDouble(), sortedEntries[index].value);
    });
  }

  Widget getTitles(double value, TitleMeta meta) {
    final spots = _generateSpots();
    if (value.toInt() >= spots.length) return const SizedBox.shrink();

    final date = sales[value.toInt()].timestamp;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        DateFormat('MM/dd').format(date),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
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
                      getTitlesWidget: getTitles,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateSpots(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.8), color],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.15),
                          color.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}