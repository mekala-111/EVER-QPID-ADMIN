import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/transactiondetails/widgets/detailrow.dart';
import 'package:flutter/material.dart';

class PaymentDetailsCard extends StatelessWidget {
  final String paymentMethod;
  final String paymentReference;
  final int planAmount;
  final int taxAmount;
  final int totalAmount;

  const PaymentDetailsCard({
    super.key,
    required this.paymentMethod,
    required this.paymentReference,
    required this.planAmount,
    required this.taxAmount,
    required this.totalAmount,
  });

  String _formatAmount(int value) => '₹${value.toString()}';

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
              'Payment Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            DetailRow(label: 'Payment Method', value: paymentMethod),
            DetailRow(label: 'Payment Reference', value: paymentReference),
            const Divider(height: 32),
            DetailRow(label: 'Plan Amount', value: _formatAmount(planAmount)),
            DetailRow(
              label: 'Taxes (GST 18%)',
              value: _formatAmount(taxAmount),
            ),
            const Divider(height: 32),
            DetailRow(
              label: 'Total Amount',
              value: _formatAmount(totalAmount),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}
