import 'package:everqpidadmin/Features/revanuemanagement/revenue/view_model/revenue_chart_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class RevenueCardsWidget extends StatelessWidget {
  const RevenueCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenueChartProvider>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.revenueSummary == null) {
          return const SizedBox(
            height: 110,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final summary = vm.revenueSummary;

        if (summary == null) {
          return const SizedBox.shrink();
        }

        final cards = [
          RevenueCardData(
            title: 'Total Revenue',
            value: '₹${summary.totalRevenue}',
          ),
          RevenueCardData(
            title: 'Avg Revenue / User',
            value: '₹${summary.averageRevenuePerUser}',
          ),
          RevenueCardData(
            title: 'Active Plans',
            value: '₹${summary.activePlansTotalAmount}',
          ),
        ];

        return Container(
          width: 1060,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cards
                .map(
                  (card) => _RevenueCard(
                    title: card.title,
                    value: card.value,
                    growth: card.growth,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class RevenueCardData {
  final String title;
  final String value;
  final double? growth;

  RevenueCardData({
    required this.title,
    required this.value,
    this.growth,
  });
}

class _RevenueCard extends StatelessWidget {
  final String title;
  final String value;
  final double? growth;

  const _RevenueCard({
    required this.title,
    required this.value,
    this.growth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 107,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF67728D),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),

          // Value + growth
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF091128),
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (growth != null) ...[
                const SizedBox(width: 8),
                Icon(
                  growth! >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: growth! >= 0 ? const Color(0xFF59BE1C) : Colors.red,
                ),
                Text(
                  "${growth!.abs().toStringAsFixed(1)}%",
                  style: TextStyle(
                    color: growth! >= 0 ? const Color(0xFF59BE1C) : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
