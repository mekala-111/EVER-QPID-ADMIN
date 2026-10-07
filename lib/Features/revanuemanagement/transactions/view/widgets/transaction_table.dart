import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transaction_provider.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transactiondetails_provider.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/transaction_list_model.dart';

class TransactionTable extends StatelessWidget {
  const TransactionTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && !provider.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(60),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.hasError && !provider.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    provider.error ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!provider.hasData || provider.transactions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(60),
              child: Text(
                'No transactions available',
                style: TextStyle(color: Color(0xFF67728D)),
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                  4: FlexColumnWidth(1.2),
                  5: FlexColumnWidth(1.5),
                  6: FlexColumnWidth(1),
                },
                children: [
                  // Header Row
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE4E7EB),
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeader('User'),
                      _buildHeader('Transaction ID'),
                      _buildHeader('Date'),
                      _buildHeader('Plan'),
                      _buildHeader('Status'),
                      _buildHeader('Amount'),
                      _buildHeader('Action', isLast: true),
                    ],
                  ),
                  // Data Rows
                  ...provider.transactions
                      .map((txn) => _buildDataRow(txn, provider, context)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE4E7EB)),
            _buildPaginationFooter(provider),
          ],
        );
      },
    );
  }

  Widget _buildHeader(String text, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF67728D),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        textAlign: isLast ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  TableRow _buildDataRow(
    TransactionItem txn,
    TransactionProvider provider,
    BuildContext context,
  ) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      children: [
        _buildCell(txn.userName),
        _buildCell(txn.transactionId),
        _buildCell(provider.formatDate(txn.createdAt)),
        _buildCell(txn.planName),
        _buildStatusCell(txn.status),
        _buildCell(provider.formatAmount(txn.amount)),
        _buildActionCell(context, txn.transactionId),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF091128),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    final statusMap = {
      'Success': {'bg': Colors.green, 'text': Colors.white, 'label': 'Success'},
      'Failed': {'bg': Colors.red, 'text': Colors.white, 'label': 'Failed'},
      'Pending': {
        'bg': Colors.yellow,
        'text': Colors.white,
        'label': 'Pending'
      },
    };

    final config = statusMap[status] ??
        {
          'bg': const Color(0xFFF3F4F6),
          'text': const Color(0xFF6B7280),
          'label': status
        };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: config['bg'] as Color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          config['label'] as String,
          style: TextStyle(
            color: config['text'] as Color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionCell(
    BuildContext context,
    String transactionId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            // Navigation logic

            context
                .read<TransactionDetailsProvider>()
                .fetchTransactionDetails(transactionId);
            context
                .read<WrapperViewModel>()
                .updatePageIndex(GetWrapperPageViewStatus.transactionDeatils);
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: PColors.primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'View',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(TransactionProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E7EB)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButton<int>(
              value: provider.rowsPerPage,
              items: [5, 10, 20, 50].map((v) {
                return DropdownMenuItem(
                  value: v,
                  child: Text(
                    '$v per page',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF091128),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (v) => v != null ? provider.setRowsPerPage(v) : null,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
            ),
          ),
          Row(
            children: [
              Text(
                provider.paginationInfo,
                style: const TextStyle(
                  color: Color(0xFF67728D),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: provider.canGoBack ? provider.previousPage : null,
                style: IconButton.styleFrom(
                  backgroundColor: provider.canGoBack
                      ? Colors.white
                      : const Color(0xFFF9FAFB),
                  side: const BorderSide(color: Color(0xFFE4E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: provider.canGoForward ? provider.nextPage : null,
                style: IconButton.styleFrom(
                  backgroundColor: provider.canGoForward
                      ? Colors.white
                      : const Color(0xFFF9FAFB),
                  side: const BorderSide(color: Color(0xFFE4E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
