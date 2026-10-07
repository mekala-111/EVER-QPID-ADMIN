import 'package:everqpidadmin/Features/dashboard/view/widgets/sumarycard.dart';
import 'package:everqpidadmin/Features/usermanagement/view/allusers/widgets/usertable.dart';
import 'package:everqpidadmin/Features/usermanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../Settings/utils/p_colors.dart';

// Import the female filter bar widget

class FemaleusersScreen extends StatefulWidget {
  const FemaleusersScreen({super.key});

  @override
  State<FemaleusersScreen> createState() => _FemaleusersScreenState();
}

const String totalUsers = "150";
const String activeCustomers = "120";
const String newSignupsThisMonth = "18";

class _FemaleusersScreenState extends State<FemaleusersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<UsersViewModel>();
      // Set gender filter to "female"
      viewModel.setGenderFilter("Women");
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
                  text: "Female Users",
                  fontweight: FontWeight.w700,
                  fontsize: 20,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: PColors.color042F40),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      textWidget(
                        text: "Female",
                        fontsize: 13,
                        color: PColors.color353534,
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.female,
                        color: Colors.pink,
                        size: 18,
                      ),
                    ],
                  ),
                ),
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
                        value: viewmodel.tatalfeMale.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "Active Customers",
                        value: viewmodel.totalActiveFemaleUsers.toString(),
                        changeText: "",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        title: "New Sign-ups (This Month)",
                        value: viewmodel.newFemaleSignupsThisMonth.toString(),
                        changeText: "",
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            /// Filter Bar

            const SizedBox(height: 16),

            /// User Table
            const UserTable(),
          ],
        ),
      ),
    );
  }
}
