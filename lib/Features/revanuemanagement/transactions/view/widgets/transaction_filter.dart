import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../Settings/utils/p_colors.dart';

class TransactionFilter extends StatefulWidget {
  const TransactionFilter({super.key});

  @override
  State<TransactionFilter> createState() => _CustomerFilterState();
}

class _CustomerFilterState extends State<TransactionFilter> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          context.read<TransactionProvider>().setFromDate(picked);
        } else {
          _toDate = picked;
          context.read<TransactionProvider>().setToDate(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Container(
      width: 1028,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  'All Transactions',
                  style: TextStyle(
                    color: const Color(0xFF091128),
                    fontSize: 17,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔍 Search Field
              SizedBox(
                width: 282,
                height: 41,
                child: TextField(
                  onChanged: (value) {
                    context.read<TransactionProvider>().setSearchQuery(value);
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone',
                    hintStyle: const TextStyle(
                      color: Color(0xFF67728D),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Color(0xFF67728D),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE4E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE4E7EB)),
                    ),
                  ),
                ),
              ),

              // 🟡 Status Dropdown
              SizedBox(
                width: 127,
                height: 41,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF67728D),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE4E7EB)),
                    ),
                  ),
                  hint: const Text(
                    'Status (All)',
                    style: TextStyle(
                      color: Color(0xFF67728D),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'success', child: Text('Success')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'failed', child: Text('Failed')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedStatus = value);
                    context.read<TransactionProvider>().setStatus(value);
                  },
                ),
              ),

              // 📅 From Date
              _buildDatePickerButton(
                label: _fromDate == null
                    ? 'From'
                    : 'From: ${dateFormat.format(_fromDate!)}',
                onTap: () => _pickDate(context, true),
              ),

              // 📅 To Date
              _buildDatePickerButton(
                label: _toDate == null
                    ? 'To'
                    : 'To: ${dateFormat.format(_toDate!)}',
                onTap: () => _pickDate(context, false),
              ),

              // 🎯 Filter Button
              GestureDetector(
                onTap: () {
                  context.read<TransactionProvider>().fetchTransactions(
                        page: 1,
                      );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: ShapeDecoration(
                    color: PColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Filter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              // 🧹 Clear Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _selectedStatus = null;
                    _fromDate = null;
                    _toDate = null;
                  });

                  context.read<TransactionProvider>().clearFilters();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFE4E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      color: Color(0xFF67728D),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDatePickerButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFE4E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Color(0xFF67728D),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF67728D),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
