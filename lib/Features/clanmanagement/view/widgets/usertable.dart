import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:everqpidadmin/Features/clanmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';

class ClanUserTable extends StatelessWidget {
  const ClanUserTable({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size / 1.3;

    return Container(
      decoration: BoxDecoration(
        color: PColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PColors.color042F40),
      ),
      padding: const EdgeInsets.all(16),
      child: Consumer<ClanManagementViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                text: "Clan Users",
                fontweight: FontWeight.bold,
                fontsize: 16,
              ),

              const SizedBox(height: 12),

              /// TABLE
              Expanded(
                child: vm.clanUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_off,
                              size: 48,
                              color: PColors.color353534.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 12),
                            textWidget(
                              text: "No users found",
                              fontsize: 14,
                              fontweight: FontWeight.w500,
                              color: PColors.color353534.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: size.width),
                          child: DataTable(
                            showCheckboxColumn: false,
                            dividerThickness: 0,
                            columns: _columns(),
                            rows: _rows(vm),
                          ),
                        ),
                      ),
              ),

              /// PAGINATION
              if (vm.clanUsers.isNotEmpty) ...[
                const SizedBox(height: 12),
                _pagination(context, vm),
              ]
            ],
          );
        },
      ),
    );
  }

  /// ---------------- COLUMNS ----------------
  List<DataColumn> _columns() {
    return [
      _col("Name"),
      _col("Contact"),
      _col("Gender"),
      _col("Location"),
      _col("Status"),
      _col("Clan"),
    ];
  }

  DataColumn _col(String text) => DataColumn(
        label: textWidget(
          text: text,
          fontsize: 12,
          fontweight: FontWeight.w600,
          color: PColors.color353534,
        ),
      );

  /// ---------------- ROWS ----------------
  List<DataRow> _rows(ClanManagementViewModel vm) {
    return vm.clanUsers.map((user) {
      final location =
          "${user.location?.city ?? "-"} ${user.location?.state ?? ""}".trim();

      return DataRow(
        cells: [
          DataCell(_txt(user.fullName)), // Name
          DataCell(_txt(user.mobileNumber)), // Contact
          DataCell(_txt(user.gender)), // Gender
          DataCell(_txt(location)), // Location
          DataCell(_statusChip(user.customerStatus)), // Status
          DataCell(_txt(user.clanType)), // Clan
        ],
      );
    }).toList();
  }

  Widget _txt(String text) => textWidget(
        text: text,
        fontsize: 12,
        fontweight: FontWeight.w400,
        color: PColors.color353534,
      );

  /// ---------------- STATUS CHIP ----------------
  Widget _statusChip(String status) {
    final isActive = status.toLowerCase() == "active";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  /// ---------------- PAGINATION ----------------
  Widget _pagination(BuildContext context, ClanManagementViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: vm.currentPage > 1 ? () => vm.prevPage(context) : null,
          icon: const Icon(Icons.arrow_back),
        ),
        Text(
          "Page ${vm.currentPage} of ${vm.totalPages}",
        ),
        IconButton(
          onPressed: vm.currentPage < vm.totalPages
              ? () => vm.nextPage(context)
              : null,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
