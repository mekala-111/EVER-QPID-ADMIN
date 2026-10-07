// import 'package:everqpidadmin/Settings/utils/p_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../model/transaction_list_model.dart';

// class TransactionDetailsPage extends StatelessWidget {

//   const TransactionDetailsPage({super.key, required this.transaction});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: PColors.scaffoldColor2,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             _buildHeader(),

//             const SizedBox(height: 8),

//             // Breadcrumb
//             _buildBreadcrumb(),

//             const SizedBox(height: 32),

//             // Cards
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(child: _buildTransactionCard()),
//                 const SizedBox(width: 28),
//                 Expanded(child: _buildPaymentDetailsCard()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Text(
//       'Transaction Details - ${transaction.transactionId}',
//       style: const TextStyle(
//         color: Color(0xFF091128),
//         fontSize: 29,
//         fontFamily: 'Roboto',
//         fontWeight: FontWeight.w700,
//         height: 1.20,
//       ),
//     );
//   }

//   Widget _buildBreadcrumb() {
//     return Text.rich(
//       TextSpan(
//         children: [
//           const TextSpan(
//             text: 'Admin / All Transactions / ',
//             style: TextStyle(
//               color: Color(0xFF67728D),
//               fontSize: 14,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w400,
//               height: 1.50,
//             ),
//           ),
//           TextSpan(
//             text: transaction.transactionId,
//             style: const TextStyle(
//               color: Color(0xFF67728D),
//               fontSize: 14,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w600,
//               height: 1.50,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color(0xFFE5E8EC)),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(23, 21, 23, 16),
//             child: const Text(
//               'Transaction',
//               style: TextStyle(
//                 color: Color(0xFF091128),
//                 fontSize: 17,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w500,
//                 height: 1.30,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 23),
//             child: Column(
//               children: [
//                 _buildDetailRow('Date & Time:', _formatDateTime()),
//                 _buildDetailRow('Transaction ID:', transaction.transactionId),
//                 _buildDetailRow(
//                   'Booking ID:',
//                   transaction.bookingId?.toString() ?? 'N/A',
//                 ),
//                 _buildDetailRow('Type:', transaction.type),
//                 _buildDetailRow('Payment:', _formatAmount(transaction.amount)),
//                 _buildStatusRow('Status:', transaction.status),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentDetailsCard() {
//     // Calculate amounts
//     int planAmount = transaction.bookingAmount ?? transaction.amount;
//     double gstRate = 0.18; // 18% GST
//     int gstAmount = (planAmount * gstRate).round();
//     int totalAmount = transaction.amount;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color(0xFFE5E8EC)),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(23, 21, 23, 16),
//             child: const Text(
//               'Payment Details',
//               style: TextStyle(
//                 color: Color(0xFF091128),
//                 fontSize: 17,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w500,
//                 height: 1.30,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 23),
//             child: Column(
//               children: [
//                 _buildDetailRow('Payment Method', 'UPI'), // Assuming UPI
//                 _buildDetailRow(
//                   'Payment Reference',
//                   'UPI-REF-${transaction.transactionId.replaceAll('TXN', '')}',
//                 ),
//                 const SizedBox(height: 15),
//                 _buildDetailRow('Plan Amount:', _formatAmount(planAmount)),
//                 // _buildDetailRow('Taxes (GST 18%):', _formatAmount(gstAmount)),
//                 const SizedBox(height: 15),
//                 _buildTotalRow('Total Amount:', _formatAmount(totalAmount)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE5E8EC))),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: 152,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Color(0xFF67728D),
//                 fontSize: 14,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w400,
//                 height: 1.60,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 color: Color(0xFF091128),
//                 fontSize: 14,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w400,
//                 height: 1.30,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusRow(String label, String status) {
//     Color statusColor;
//     switch (status.toLowerCase()) {
//       case 'success':
//         statusColor = const Color(0xFF37A43C);
//         break;
//       case 'pending':
//         statusColor = const Color(0xFF4A60FF);
//         break;
//       case 'failed':
//         statusColor = const Color(0xFFD32F2F);
//         break;
//       case 'refunded':
//         statusColor = const Color(0xFFB56A00);
//         break;
//       default:
//         statusColor = const Color(0xFF67728D);
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE5E8EC))),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: 117,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Color(0xFF67728D),
//                 fontSize: 14,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w400,
//                 height: 1.60,
//               ),
//             ),
//           ),
//           Text(
//             status[0].toUpperCase() + status.substring(1),
//             style: TextStyle(
//               color: statusColor,
//               fontSize: 14,
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w500,
//               height: 1.50,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTotalRow(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE5E8EC))),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: 117,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Color(0xFF67728D),
//                 fontSize: 14,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w600,
//                 height: 1.60,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Color(0xFF091128),
//               fontSize: 14,
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w600,
//               height: 1.30,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDateTime() {
//     final dateStr = DateFormat('yyyy-MM-dd').format(transaction.date);
//     return '$dateStr, ${transaction.time}';
//   }

//   String _formatAmount(int amount) {
//     return '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
//   }
// }
