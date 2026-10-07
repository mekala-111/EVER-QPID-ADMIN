import 'package:everqpidadmin/Features/Ticketmanagement/view/widgets/addticket.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/view/widgets/tickettable.dart';
import 'package:everqpidadmin/Features/dashboard/view/widgets/sumarycard.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../Settings/utils/p_colors.dart';

// ALL TICKETS PAGE
class AllTicketsScreen extends StatefulWidget {
  const AllTicketsScreen({super.key});

  @override
  State<AllTicketsScreen> createState() => _AllTicketsScreenState();
}

class _AllTicketsScreenState extends State<AllTicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<TicketsViewModel>();
      viewModel.getAllTicketsFn(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.scaffoldColor2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                  text: "All Tickets",
                  fontweight: FontWeight.w700,
                  fontsize: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                              width: 500, // desktop friendly
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: AddTicketForm(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: PColors.primaryColor,
                        // border: Border.all(color: const Color(0xff4BAF4F)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'ADD TICKETS +',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Summary Cards Row
            Consumer<TicketsViewModel>(
              builder: (context, viewmodel, child) {
                final openTickets = viewmodel.tickets
                    .where((t) => t.status.toLowerCase() == 'open')
                    .length;
                final closedTickets = viewmodel.tickets
                    .where((t) => t.status.toLowerCase() == 'closed')
                    .length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "Total Tickets",
                        value: viewmodel.tickets.length.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Open Tickets",
                        value: openTickets.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Closed Tickets",
                        value: closedTickets.toString(),
                        changeText: "",
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            /// Ticket Table
            const TicketTable(),
          ],
        ),
      ),
    );
  }
}
