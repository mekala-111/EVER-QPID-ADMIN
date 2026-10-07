// import 'package:everqpidadmin/Features/revanuemanagement/revenue/view_model/revenue_chart_provider.dart';
// import 'package:everqpidadmin/Features/revanuemanagement/revenue/view_model/revenue_provider.dart';
// import 'package:everqpidadmin/Settings/utils/p_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class RevenueFilterWidget extends StatefulWidget {
//   const RevenueFilterWidget({super.key});

//   @override
//   State<RevenueFilterWidget> createState() => _RevenueFilterWidgetState();
// }

// class _RevenueFilterWidgetState extends State<RevenueFilterWidget> {
//   String? selectedLanguage = "All";
//   String? selectedService = "All";
//   DateTime? fromDate;
//   DateTime? toDate;

//   final List<String> languages = ["All", "English", "Hindi", "Malayalam"];
//   final List<String> services = ["All", "Chat", "Call", "Video"];

//   Future<void> _pickDate(BuildContext context, bool isFrom) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFrom) {
//           fromDate = picked;
//         } else {
//           toDate = picked;
//         }
//       });
//     }
//   }

//   void _clearFilters() {
//     setState(() {
//       selectedLanguage = "All";
//       selectedService = "All";
//       fromDate = null;
//       toDate = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 1060,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color(0xFFE4E7EB)),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Filters',
//             style: TextStyle(
//               color: Color(0xFF091128),
//               fontSize: 17,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               // _buildDropdownField(
//               //   label: "Language",
//               //   value: selectedLanguage,
//               //   items: languages,
//               //   onChanged: (val) => setState(() => selectedLanguage = val),
//               // ),
//               // const SizedBox(width: 20),
//               // _buildDropdownField(
//               //   label: "Service",
//               //   value: selectedService,
//               //   items: services,
//               //   onChanged: (val) => setState(() => selectedService = val),
//               // ),
//               // const SizedBox(width: 20),
//               _buildDateField(
//                 label: "From",
//                 date: fromDate,
//                 onTap: () => _pickDate(context, true),
//               ),
//               const SizedBox(width: 20),
//               _buildDateField(
//                 label: "To",
//                 date: toDate,
//                 onTap: () => _pickDate(context, false),
//               ),
//               const SizedBox(width: 20),
//               // In revenue_filter.dart
//               _buildActionButton(
//                 "Apply",
//                 PColors.primaryColor,
//                 Colors.white,
//                 () {
//                   context.read<RevenueChartProvider>().fetchRevenueChart(
//                         from: fromDate,
//                         to: toDate,
//                       );
//                 },
//               ),

//               const SizedBox(width: 10),
//               _buildActionButton(
//                 "Clear",
//                 const Color(0xFFFFD600),
//                 Colors.white,
//                 _clearFilters,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateField({
//     required String label,
//     required DateTime? date,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       width: 190,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(color: Color(0xFF67728D), fontSize: 14),
//           ),
//           const SizedBox(height: 6),
//           GestureDetector(
//             onTap: onTap,
//             child: Container(
//               height: 41,
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFE4E7EB)),
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//               ),
//               child: Text(
//                 date == null
//                     ? "DD/MM/YYYY"
//                     : DateFormat('dd/MM/yyyy').format(date),
//                 style: const TextStyle(color: Color(0xFF67728D), fontSize: 14),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(
//     String text,
//     Color bgColor,
//     Color textColor,
//     VoidCallback onPressed,
//   ) {
//     return Container(
//       height: 41,
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextButton(
//         onPressed: onPressed,
//         child: Text(text, style: TextStyle(color: textColor, fontSize: 14)),
//       ),
//     );
//   }
// }
