import 'package:everqpidadmin/Features/revanuemanagement/revenue/view/widgets/revenue_cards.dart';
import 'package:everqpidadmin/Features/revanuemanagement/revenue/view/widgets/revenue_chart.dart';
import 'package:everqpidadmin/Features/revanuemanagement/revenue/view/widgets/revenue_header.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../transactions/view/widgets/revenue_filter.dart';
import '../view_model/revenue_chart_provider.dart';

class RevenueUi extends StatefulWidget {
  const RevenueUi({super.key});

  @override
  State<RevenueUi> createState() => _RevenueUiState();
}

class _RevenueUiState extends State<RevenueUi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RevenueChartProvider>().fetchRevenueChart();
      context.read<RevenueChartProvider>().fetchRevenueSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: PColors.scaffoldColor2),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RevenueHeaderWidget(),
            RevenueCardsWidget(), // ✅ Uses RevenueDetailProvider
            RevenueFilterWidget(), // ✅ Uses RevenueChartProvider
            RevenueChartWidget(), // ✅ Uses RevenueChartProvider
          ],
        ),
      ),
    );
  }
}
