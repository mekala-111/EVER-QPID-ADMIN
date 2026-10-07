import 'package:everqpidadmin/Features/employeemanagement/view/widgets/addform.dart';
import 'package:everqpidadmin/Features/employeemanagement/view/widgets/employeetable.dart';
import 'package:everqpidadmin/Features/employeemanagement/view/widgets/filterwidget.dart';
import 'package:everqpidadmin/Features/employeemanagement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeViewModel>().getEmployees(context);
    });
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AddEditEmployeeForm(),
            ),
          ),
        );
      },
    );
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
                  text: "Employee Management",
                  fontweight: FontWeight.w700,
                  fontsize: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: GestureDetector(
                    onTap: _showAddEmployeeDialog,
                    child: Container(
                      decoration: BoxDecoration(
                        color: PColors.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'ADD Employee +',
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

            /// Main Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PColors.color042F40),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Table Title and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWidget(
                        text: "Employees List",
                        fontweight: FontWeight.bold,
                        color: Colors.black,
                        fontsize: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Filter Bar
                  Consumer<EmployeeViewModel>(
                    builder: (context, vm, _) {
                      return EmployeeFilterBar(
                        onSearch: ({
                          required search,
                          required status,
                          required role,
                          fromDate,
                          toDate,
                        }) {
                          vm.searchQuery = search.isEmpty ? null : search;
                          vm.selectedStatus = status.isEmpty
                              ? null
                              : '${status[0].toUpperCase()}${status.substring(1).toLowerCase()}';
                          vm.selectedRole = role.isEmpty ? null : role;
                          vm.fromDate = fromDate;
                          vm.toDate = toDate;
                          vm.currentPage = 1;
                          vm.getEmployees(context);
                        },
                        onClear: () {
                          vm.clearFilters();
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  /// Table
                  const EmployeeTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
