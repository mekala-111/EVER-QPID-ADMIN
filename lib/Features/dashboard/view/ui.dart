import 'package:everqpidadmin/Features/dashboard/view/widgets/usersbreakdown.dart';
import 'package:everqpidadmin/Features/dashboard/view/widgets/userchart.dart';
import 'package:everqpidadmin/Features/dashboard/view/widgets/sumarycard.dart';
import 'package:everqpidadmin/Features/dashboard/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Settings/utils/p_colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<DashboardViewmodel>();
      vm.fetchUserGenderChart();
      vm.fetchMostActiveClans();
      vm.fetchDashboardSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.scaffoldColor2,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Top section ---
                Row(
                  children: [
                    textWidget(
                      text: "Dashboard",
                      fontsize: 22,
                      fontweight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 12, vertical: 8),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: PColors.color042F40),
                        //     borderRadius: BorderRadius.circular(8),
                        //     color: Colors.white,
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       textWidget(
                        //         text: "This month",
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
                        const SizedBox(width: 12),
                        Consumer<DashboardViewmodel>(
                          builder: (context, vm, _) {
                            return ElevatedButton(
                              onPressed: vm.csvLoading
                                  ? null
                                  : () async {
                                      await vm.downloadDashboardCsvWeb();

                                      if (!context.mounted) return;

                                      if (vm.csvError != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(vm.csvError!)),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "CSV downloaded successfully"),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: vm.csvLoading
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "Export CSV",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                Consumer<DashboardViewmodel>(
                  builder: (context, vm, _) {
                    /// 🔄 Loading
                    if (vm.summaryLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    /// ❌ Error
                    if (vm.summaryError != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            vm.summaryError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    /// ⚠️ No Data
                    if (vm.dashboardSummary == null) {
                      return const SizedBox.shrink();
                    }

                    /// ✅ Success UI
                    final summary = vm.dashboardSummary!;

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: "Total Revenue",
                                value: summary.revenue.toString(),
                                changeText: "+37%",
                                isPositive: true,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SummaryCard(
                                title: "Total Users",
                                value: summary.totalUsers.toString(),
                                changeText: "-23%",
                                isPositive: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: "Total Male Users",
                                value: summary.menUsers.toString(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SummaryCard(
                                title: "Active Female Users",
                                value: summary.womenUsers.toString(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// --- Chart + Breakdown ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(flex: 3, child: Userchart()),
                    SizedBox(width: 20),
                    Expanded(flex: 1, child: Usersbreakdown()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
