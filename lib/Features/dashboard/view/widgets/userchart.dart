import 'package:everqpidadmin/Features/dashboard/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class Userchart extends StatelessWidget {
  const Userchart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewmodel>(
      builder: (context, vm, child) {
        return Container(
          height: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  textWidget(
                    text: "Users Overview",
                    fontsize: 14,
                    fontweight: FontWeight.w500,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.purpleAccent,
                        size: 10,
                      ),
                      textWidget(
                        text: "Female Users",
                        fontsize: 14,
                        fontweight: FontWeight.w400,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                        size: 10,
                      ),
                      textWidget(
                        text: "Male Users",
                        fontsize: 14,
                        fontweight: FontWeight.w400,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 10,
                      ),
                      textWidget(
                        text: "Other",
                        fontsize: 14,
                        fontweight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: _buildChartContent(vm),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartContent(DashboardViewmodel vm) {
    if (vm.genderChartLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (vm.genderChartError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 12),
            Text(
              'Failed to load chart data',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              vm.genderChartError!,
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (vm.genderChart == null) {
      return Center(child: Text('No data available'));
    }

    final data = vm.genderChart!;

    // Convert month names to indices (Jan=1, Feb=2, etc.)
    final Map<String, int> monthMap = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    // Create spots for each gender
    List<FlSpot> maleSpots = [];
    List<FlSpot> femaleSpots = [];
    List<FlSpot> otherSpots = [];

    for (int i = 0; i < data.months.length; i++) {
      double x = monthMap[data.months[i]]?.toDouble() ?? (i + 1).toDouble();
      maleSpots.add(FlSpot(x, data.man[i].toDouble()));
      femaleSpots.add(FlSpot(x, data.women[i].toDouble()));
      otherSpots.add(FlSpot(x, data.other[i].toDouble()));
    }

    // Calculate max Y value for dynamic scaling
    final allValues = [...data.man, ...data.women, ...data.other];
    final maxValue =
        allValues.isEmpty ? 0 : allValues.reduce((a, b) => a > b ? a : b);

    final maxY = maxValue == 0
        ? 25 // fallback scale when all values are zero
        : ((maxValue / 25).ceil() * 25).toDouble();

    return LineChart(
      LineChartData(
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.black12),
            left: BorderSide(color: Colors.black12),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.black12,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                if (value >= 1000) {
                  return Text('${(value / 1000).toStringAsFixed(0)}k');
                }
                return Text(value.toInt().toString());
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const months = [
                  '',
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                int index = value.toInt();
                if (index >= 1 && index <= 12) {
                  return Text(months[index]);
                }
                return const Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: maxY.toDouble(),
        lineBarsData: [
          // Male Users Line
          LineChartBarData(
            spots: maleSpots,
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            barWidth: 3,
          ),
          // Female Users Line
          LineChartBarData(
            spots: femaleSpots,
            isCurved: true,
            color: Colors.purpleAccent,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            barWidth: 3,
          ),
          // Other Users Line
          LineChartBarData(
            spots: otherSpots,
            isCurved: true,
            color: Colors.green,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            barWidth: 3,
          ),
        ],
      ),
    );
  }
}
