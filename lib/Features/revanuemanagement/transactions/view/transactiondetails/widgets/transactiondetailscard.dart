import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/transactiondetails/widgets/detailrow.dart';
import 'package:flutter/material.dart';

class TransactionDetailsCard extends StatelessWidget {
  final String dateTime;
  final String transactionId;
  final String userName;
  final String planName;
  final String coins;
  final String status;

  const TransactionDetailsCard({
    super.key,
    required this.dateTime,
    required this.transactionId,
    required this.userName,
    required this.planName,
    required this.coins,
    required this.status,
  });

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xffE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            DetailRow(label: 'Date & Time:', value: dateTime),
            DetailRow(label: 'Transaction ID:', value: transactionId),
            DetailRow(label: 'User Name:', value: userName),
            DetailRow(label: 'Plan Name / Type:', value: planName),
            DetailRow(label: 'Coins / Gems:', value: coins),
            DetailRow(
              label: 'Status:',
              value: status,
              valueColor: _statusColor(),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}
