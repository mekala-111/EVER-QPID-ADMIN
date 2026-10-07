import 'package:everqpidadmin/Features/dashboard/view/widgets/sumarycard.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/allhost/widgets/hosttable.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../Settings/utils/p_colors.dart';

class ActiveHostsScreen extends StatefulWidget {
  const ActiveHostsScreen({super.key});

  @override
  State<ActiveHostsScreen> createState() => _ActiveHostsScreenState();
}

class _ActiveHostsScreenState extends State<ActiveHostsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<HostmanagementViewmodel>();
      viewModel.initializeForPage(
          context, 'Active'); // All hosts (status = null)
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
                  text: "Active Hosts",
                  fontweight: FontWeight.w700,
                  fontsize: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HostmanagementViewmodel>().clearEditMode();
// Navigate to add host page
                    context
                        .read<WrapperViewModel>()
                        .updatePageIndex(GetWrapperPageViewStatus.addHost);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PColors.primaryColor,
                    minimumSize: const Size(0, 48), // 👈 height increased here
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add Host +",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Summary Cards Row
            Consumer<HostmanagementViewmodel>(
              builder: (context, viewmodel, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "Total Hosts",
                        value: viewmodel.totalHosts.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Active Hosts",
                        value: viewmodel.activeHosts.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Inactive Hosts",
                        value: viewmodel.inactiveHosts.toString(),
                        changeText: "",
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            /// Host Table
            const HostTable(),
          ],
        ),
      ),
    );
  }
}
