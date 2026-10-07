import 'package:everqpidadmin/Features/dashboard/view/widgets/sumarycard.dart';
import 'package:everqpidadmin/Features/usermanagement/view/allusers/widgets/usertable.dart';
import 'package:everqpidadmin/Features/usermanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../../../../Settings/utils/p_colors.dart';

class MaleusersScreen extends StatefulWidget {
  const MaleusersScreen({super.key});

  @override
  State<MaleusersScreen> createState() => _MaleusersScreenState();
}

// const String totalUsers = "150";
// const String activeCustomers = "120";
// const String newSignupsThisMonth = "18";

class _MaleusersScreenState extends State<MaleusersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<UsersViewModel>();
      // Set gender filter to "female"
      viewModel.setGenderFilter("Man");
      viewModel.getAllUsersFn(context);
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
                  text: "User Management",
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
                //         text: "All",
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

            /// Summary Cards Row (Dummy Data)
            /// Summary Cards Row
            Consumer<UsersViewModel>(
              builder: (context, viewmodel, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "Total Users",
                        value: viewmodel.tatalMale.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Active Customers",
                        value: viewmodel.totalActiveMaleUsers.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "New Sign-ups (This Month)",
                        value: viewmodel.newMaleSignupsThisMonth.toString(),
                        changeText: "",
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            /// User Table (already frontend-only)
            UserTable(),
          ],
        ),
      ),
    );
  }
}
