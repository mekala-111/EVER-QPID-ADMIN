import 'package:everqpidadmin/Features/dashboard/view/widgets/sumarycard.dart';
import 'package:everqpidadmin/Features/usermanagement/view/reportedusers/widgets/usertable.dart';
import 'package:everqpidadmin/Features/usermanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../Settings/utils/p_colors.dart';

class ReportedUsersScreen extends StatefulWidget {
  const ReportedUsersScreen({super.key});

  @override
  State<ReportedUsersScreen> createState() => _ReportedUsersScreenState();
}

class _ReportedUsersScreenState extends State<ReportedUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<UsersViewModel>();
      viewModel.getReportedUsersFn(context);
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
              children: [
                textWidget(
                  text: "Reported Users",
                  fontweight: FontWeight.w700,
                  fontsize: 20,
                ),
                // const Spacer(),
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 12,
                //     vertical: 8,
                //   ),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: PColors.color042F40),
                //     borderRadius: BorderRadius.circular(8),
                //     color: Colors.white,
                //   ),
                //   child: Row(
                //     children: [
                //       textWidget(
                //         text: "All Reports",
                //         fontsize: 13,
                //         color: PColors.color353534,
                //       ),
                //       const SizedBox(width: 6),
                //       const Icon(
                //         Icons.keyboard_arrow_down_rounded,
                //         color: Colors.black54,
                //         size: 18,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 20),

            /// Summary Cards Row
            Consumer<UsersViewModel>(
              builder: (context, viewmodel, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "Total Users",
                        value: viewmodel.reportedUsersCount.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Male Users",
                        value: viewmodel.reportedUsersCountmale.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Female Users",
                        value: viewmodel.reportedUsersCountfemale.toString(),
                        changeText: "",
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            /// Reported Users Table
            const ReportedUsersTable(),
          ],
        ),
      ),
    );
  }
}
