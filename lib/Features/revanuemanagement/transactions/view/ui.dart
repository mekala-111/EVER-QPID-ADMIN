import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/widgets/revenue_cards.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/widgets/transaction_filter.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/widgets/transaction_header.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view/widgets/transaction_table.dart';
import 'package:everqpidadmin/Features/revanuemanagement/transactions/view_model/transaction_provider.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionUi extends StatefulWidget {
  const TransactionUi({super.key});

  @override
  State<TransactionUi> createState() => _TransactionUiState();
}

class _TransactionUiState extends State<TransactionUi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: PColors.scaffoldColor2),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionHeaderWidget(),
            TransactionCardwidget(),
            const SizedBox(height: 10),
            // Revenue Cards Section

            TransactionBody()
          ],
        ),
      ),
    );
  }
}

class TransactionBody extends StatelessWidget {
  const TransactionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1056,
      child: Card(
        color: PColors.colorFFFFFF,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE4E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionFilter(),
            const SizedBox(height: 10),
            TransactionTable(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
