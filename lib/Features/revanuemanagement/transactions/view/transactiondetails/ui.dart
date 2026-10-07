import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/transactiondetails/widgets/paymentdetailscard.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/transactiondetails/widgets/transactiondetailscard.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transactiondetails_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactiondetailsUi extends StatelessWidget {
  const TransactiondetailsUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionDetailsProvider>(
      builder: (context, provider, _) {
        // =====================
        // Loading
        // =====================
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // =====================
        // Error
        // =====================
        if (provider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  provider.error ?? 'Something went wrong',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // retry needs transactionId (store last ID if needed)
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // =====================
        // No Data
        // =====================
        if (!provider.hasData) {
          return const Center(
            child: Text('No transaction details found'),
          );
        }

        final data = provider.details!;
        final transaction = data.transaction;
        final payment = data.paymentDetails;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================
                // Header
                // =====================
                Text(
                  'Transaction Details - ${transaction.transactionId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Admin / All Transactions / ${transaction.transactionId}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // =====================
                // Cards
                // =====================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TransactionDetailsCard(
                      dateTime: formatToLocalDateTime(
                        date: transaction.date,
                        time: transaction.time,
                      ),
                      transactionId: transaction.transactionId,
                      userName: transaction.userName,
                      planName: transaction.planName,
                      coins: payment.totalAmount.toString(),
                      status: transaction.status,
                    )),
                    const SizedBox(width: 24),
                    Expanded(
                      child: PaymentDetailsCard(
                        paymentMethod: payment.paymentMethod,
                        paymentReference: payment.paymentReference,
                        planAmount: payment.planAmount,
                        taxAmount: ((payment.planAmount * 18) / 100).round(),
                        totalAmount: payment.totalAmount,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatToLocalDateTime({
    required String date,
    required String time,
  }) {
    // Combine date & time in ISO 8601 format
    final dateTimeString = "${date}T${time}Z"; // Add 'Z' to indicate UTC

    // Parse as UTC and convert to local (IST)
    final utcDateTime = DateTime.parse(dateTimeString);
    final localDateTime = utcDateTime.toLocal();

    // Convert to 12-hour format
    final hour = localDateTime.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    // Format nicely
    return "${localDateTime.day.toString().padLeft(2, '0')}-"
        "${localDateTime.month.toString().padLeft(2, '0')}-"
        "${localDateTime.year} "
        "$hour12:"
        "${localDateTime.minute.toString().padLeft(2, '0')} $period";
  }
}
