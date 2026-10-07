import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../view_model/revenue_chart_provider.dart';

class RevenueChartWidget extends StatelessWidget {
  const RevenueChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenueChartProvider>(
      builder: (context, provider, child) {
        // Loading
        if (provider.isLoading && !provider.hasData) {
          return _stateContainer(
            child: const CircularProgressIndicator(),
          );
        }

        // Error
        if (provider.hasError && !provider.hasData) {
          return _stateContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                const Text('Error loading chart data'),
                TextButton(
                  onPressed: provider.retry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (!provider.hasData || provider.chartPoints.isEmpty) {
          return _stateContainer(
            child: const Text('No chart data available'),
          );
        }

        final chartData = provider.chartPoints;

        final List<FlSpot> spots = [];
        final List<String> months = [];

        for (int i = 0; i < chartData.length; i++) {
          final item = chartData[i];

          spots.add(
            FlSpot(i.toDouble(), item.success.toDouble()),
          );

          // "2025-12" → Dec
          final date = DateTime.parse('${item.month}-01');
          months.add(DateFormat('MMM').format(date));
        }

        return Container(
          width: 1060,
          padding: const EdgeInsets.all(20),
          decoration: _decoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaction Stats",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: PColors.primaryColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Success",
                        style: TextStyle(
                          fontSize: 12,
                          color: PColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Chart
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: const Color(0xFFE8EBF0)),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9AA1B3),
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            final index = value.toInt();
                            if (index >= 0 && index < months.length) {
                              return Text(
                                months[index],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9AA1B3),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: PColors.primaryColor,
                        barWidth: 2,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _stateContainer({required Widget child}) {
    return Container(
      width: 1060,
      height: 376,
      padding: const EdgeInsets.all(20),
      decoration: _decoration,
      child: Center(child: child),
    );
  }

  static final _decoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: const Color(0xFFE8EBF0)),
    borderRadius: BorderRadius.circular(12),
  );
}
