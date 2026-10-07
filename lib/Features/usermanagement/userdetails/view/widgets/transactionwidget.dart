import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserDetailsViewModel>();

    Color statusColor(String status) {
      switch (status.toLowerCase()) {
        case "completed":
        case "success":
          return Colors.green;
        case "refunded":
          return Colors.orange;
        case "failed":
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Transactions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _tableHeader(),
          const Divider(height: 24),
          if (vm.transactionsLoading)
            const Center(child: CircularProgressIndicator())
          else if (vm.transactions.isEmpty)
            const Center(child: Text("No transactions found"))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final tx = vm.transactions[index];
                return _tableRow(
                  id: tx.transactionId,
                  date: _formatDate(tx.date),
                  plan: tx.plan,
                  amount: "₹${tx.amount}",
                  status: tx.status,
                  statusColor: statusColor(tx.status),
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(flex: 2, child: Text("Transaction ID", style: _headerStyle)),
        Expanded(flex: 3, child: Text("Date & Time", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Plan", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Amount", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Status", style: _headerStyle)),
      ],
    );
  }

  Widget _tableRow({
    required String id,
    required String date,
    required String plan,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(id)),
        Expanded(flex: 3, child: Text(date)),
        Expanded(flex: 2, child: Text(plan)),
        Expanded(
          flex: 2,
          child:
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 13,
  color: Colors.grey,
  fontWeight: FontWeight.w500,
);
