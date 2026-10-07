import 'package:everqpidadmin/Features/employeemanagement/view/widgets/addform.dart';
import 'package:everqpidadmin/Features/employeemanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeTable extends StatelessWidget {
  const EmployeeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EmployeeViewModel>();

    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (vm.employees.isEmpty) {
      return Center(
        child: Text(
          vm.error ?? "No employees found",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Table without scroll
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(0.8), // ID
                1: FlexColumnWidth(1.5), // Name
                2: FlexColumnWidth(2), // Email
                3: FlexColumnWidth(1.2), // Role
                4: FlexColumnWidth(1), // Authority
                5: FlexColumnWidth(1.2), // Joined Date
                6: FlexColumnWidth(1), // Status
                7: FlexColumnWidth(1.5), // Actions
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  children: [
                    _headerCell("ID"),
                    _headerCell("Name"),
                    _headerCell("Email"),
                    _headerCell("Role"),
                    _headerCell("Authority"),
                    _headerCell("Joined Date"),
                    _headerCell("Status"),
                    _headerCell("Actions"),
                  ],
                ),
                // Data Rows
                ...vm.employees.map((e) => _buildTableRow(context, e, vm)),
              ],
            ),
          ),
        ),

        // Pagination at bottom
        if (vm.totalPages > 1) ...[
          const SizedBox(height: 16),
          _buildPagination(context, vm),
        ],
      ],
    );
  }

  /// ------------------------ HEADER CELL ------------------------
  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: textWidget(
        text: text,
        fontsize: 13,
        color: PColors.color353534,
        fontweight: FontWeight.w700,
      ),
    );
  }

  /// ------------------------ TABLE ROW ------------------------
  TableRow _buildTableRow(
      BuildContext context, employee, EmployeeViewModel vm) {
    String joinedDate = employee.createdAt != null
        ? employee.createdAt.toString().split(' ')[0]
        : "N/A";

    return TableRow(
      children: [
        _dataCell(employee.id),
        _dataCell(employee.name),
        _dataCell(employee.email),
        _dataCell(employee.role),
        _dataCell(employee.authorityLevel),
        _dataCell(joinedDate),
        _statusCell(employee.status.toString()),
        _actionCell(context, employee),
      ],
    );
  }

  /// ------------------------ DATA CELL ------------------------
  Widget _dataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: textWidget(
        text: text,
        fontsize: 12,
        fontweight: FontWeight.w400,
        color: PColors.color353534,
      ),
    );
  }

  /// ------------------------ STATUS CELL ------------------------
  Widget _statusCell(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              status == 'Active' ? Colors.green.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: status == 'Active'
                ? Colors.green.shade800
                : Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// ------------------------ ACTION CELL ------------------------
  Widget _actionCell(BuildContext context, employee) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () => _showEditDialog(context, employee),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () => _showDeleteConfirmation(
                    context, employee.id, employee.name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------------ PAGINATION ------------------------
  Widget _buildPagination(BuildContext context, EmployeeViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: vm.currentPage > 1 ? () => vm.prevPage(context) : null,
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            color: vm.currentPage > 1 ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Page ${vm.currentPage} of ${vm.totalPages}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: vm.currentPage < vm.totalPages
                ? () => vm.nextPage(context)
                : null,
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            color: vm.currentPage < vm.totalPages ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }

  /// ------------------------ DIALOGS ------------------------
  void _showEditDialog(BuildContext context, employee) {
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
              child: AddEditEmployeeForm(employee: employee),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text("Confirm Delete"),
          ],
        ),
        content: Text(
          "Are you sure you want to delete $name? This action cannot be undone.",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EmployeeViewModel>().deleteEmployee(context, id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
