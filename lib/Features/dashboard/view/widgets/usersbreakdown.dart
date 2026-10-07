import 'package:everqpidadmin/Features/dashboard/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class Usersbreakdown extends StatelessWidget {
  const Usersbreakdown({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewmodel>();

    if (vm.isLoadingClans) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.mostActiveClans.isEmpty) {
      return const Center(child: Text("No clan data"));
    }

    final total = vm.mostActiveClans.fold<int>(
      0,
      (sum, e) => sum + e.value,
    );

    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: textWidget(
              text: "Most Active Clans",
              fontsize: 16,
              fontweight: FontWeight.w600,
            ),
          ),

          /// 🥧 PIE CHART
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 40,
                sectionsSpace: 3,
                sections: vm.mostActiveClans.map((e) {
                  final percent = ((e.value / total) * 100).toStringAsFixed(0);
                  return PieChartSectionData(
                    value: e.value.toDouble(),
                    title: "$percent%",
                    color: _randomColor(e.label),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(),

          /// 📌 LEGEND
          ...vm.mostActiveClans.map((e) {
            final percent = ((e.value / total) * 100).toStringAsFixed(0);
            return _legendItem(
              _randomColor(e.label),
              e.label,
              "$percent%",
            );
          }),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 5, backgroundColor: color),
              const SizedBox(width: 8),
              textWidget(text: label, fontsize: 14),
            ],
          ),
          textWidget(
            text: percentage,
            fontsize: 14,
            fontweight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Color _randomColor(String key) {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.teal,
    ];
    return colors[key.hashCode % colors.length];
  }
}
