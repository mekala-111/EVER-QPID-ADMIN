import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transaction_provider.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionHeaderWidget extends StatefulWidget {
  const TransactionHeaderWidget({super.key});

  @override
  State<TransactionHeaderWidget> createState() =>
      _TransactionHeaderWidgetState();
}

class _TransactionHeaderWidgetState extends State<TransactionHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1060,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Title
          const Text(
            'All Transactions',
            style: TextStyle(
              color: Color(0xFF091128),
              fontSize: 29,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),

          // Right: Buttons
          Row(
            children: [
              // Filter Dropdown
              // _buildFilterDropdown(),
              // const SizedBox(width: 12),

              // Export Dropdown
              _buildExportDropdown(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportDropdown() {
    return Consumer<TransactionProvider>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: vm.isExporting
              ? null
              : () async {
                  await vm.exportTransactionsCsv();
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: ShapeDecoration(
              color: vm.isExporting
                  ? PColors.primaryColor.withValues(alpha: 0.6)
                  : PColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              children: [
                vm.isExporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Export CSV',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.download_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
