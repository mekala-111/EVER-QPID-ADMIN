import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/view/allusers/widgets/userfilter.dart';
import 'package:everqpidadmin/Features/usermanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            text: "Users List",
            fontweight: FontWeight.bold,
            color: Colors.black,
            fontsize: 16,
          ),
          const SizedBox(height: 10),

          // Filter Bar
          Consumer<UsersViewModel>(
            builder: (context, viewModel, _) {
              return UserFilterBar(
                onClear: () => viewModel.clearFilters(context),
                onSearch: (
                    {fromDate, required search, required status, toDate}) {
                  viewModel.searchKeyword = search.isEmpty ? null : search;
                  viewModel.fromDate = fromDate;
                  viewModel.toDate = toDate;
                  viewModel.currentPage =
                      1; // Reset to first page on new search
                  viewModel.status = status;
                  viewModel.getAllUsersFn(context);
                },
              );
            },
          ),
          const SizedBox(height: 10),

          // Table with loading and error states
          Consumer<UsersViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Show empty state without table
              if (viewModel.userList.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      viewModel.error ?? "No users found",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: size.width),
                      child: DataTable(
                        showCheckboxColumn: false,
                        dividerThickness: 0,
                        dataRowColor:
                            WidgetStateProperty.all(Colors.transparent),
                        columns: _getColumns(),
                        rows: _getRows(context, viewModel),
                      ),
                    ),
                  ),

                  // Pagination
                  const SizedBox(height: 16),
                  _buildPagination(context, viewModel),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// ------------------------ PAGINATION ------------------------
  Widget _buildPagination(BuildContext context, UsersViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: viewModel.currentPage > 1
              ? () => viewModel.prevPage(context)
              : null,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Page ${viewModel.currentPage} of ${viewModel.totalPages}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: viewModel.currentPage < viewModel.totalPages
              ? () => viewModel.nextPage(context)
              : null,
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// ------------------------ TABLE HEADERS ------------------------
  List<DataColumn> _getColumns() {
    return [
      DataColumn(label: _header("Name")),
      DataColumn(label: _header("Contact")),
      DataColumn(label: _header("Location")),
      DataColumn(label: _header("Status")),
      DataColumn(label: _header("Joined Date")),
      DataColumn(label: _header("Action")),
    ];
  }

  Widget _header(String text) {
    return textWidget(
      text: text,
      fontsize: 12,
      color: PColors.color353534,
      fontweight: FontWeight.w600,
    );
  }

  /// ------------------------ TABLE ROWS ------------------------
  List<DataRow> _getRows(BuildContext context, UsersViewModel viewModel) {
    if (viewModel.userList.isEmpty) {
      return [
        DataRow(
          cells: [
            DataCell(
              Center(
                child: Text(
                  viewModel.error ?? "No users found",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const DataCell(Text("")),
            const DataCell(Text("")),
            const DataCell(Text("")),
            const DataCell(Text("")),
            const DataCell(Text("")),
          ],
        ),
      ];
    }

    return viewModel.userList.map((user) {
      // Format status
      String status = user.isActive ? "Active" : "Inactive";
      if (user.isPaused) status = "Paused";

      // Format date
      String joinedDate = user.createdAt.toString().split(' ')[0];

      return DataRow(
        cells: [
          DataCell(_txt(user.fullName)),
          DataCell(_txt(user.mobileNumber)),
          DataCell(_txt(user.locationString)),
          DataCell(_StatusChip(status: status)),
          DataCell(_txt(joinedDate)),
          DataCell(
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () async {
                  final details = context.read<UserDetailsViewModel>();
                  final wrapper = context.read<WrapperViewModel>();
                  details.userId = user.id.toString();
                  await Future.wait([
                    details.getUserDetailsFn(context, userId: user.id),
                    details.getUserPhotosFn(
                      context,
                      userId: user.id.toString(),
                    ),
                    details.getUserMatchesFn(
                      context,
                      userId: user.id.toString(),
                    ),
                    details.getChatLogsFn(
                      context,
                      userId: user.id.toString(),
                    ),
                    details.getUserNotesFn(
                      context,
                      userId: user.id.toString(),
                    ),
                    details.getTicketsFn(
                      context,
                      userId: user.id.toString(),
                    ),
                    details.getTransactionsFn(
                      context,
                      userId: user.id.toString(),
                    ),
                  ]);

                  if (context.mounted && details.userProfile != null) {
                    wrapper.updatePageIndex(
                      GetWrapperPageViewStatus.userDetails,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "View",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ),
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
}

/// ------------------------ STATUS CHIP ------------------------
class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == "active";
    final isPaused = status.toLowerCase() == "paused";

    Color bgColor;
    Color textColor;

    if (isActive) {
      bgColor = const Color(0xFF61DF41);
      textColor = Colors.white;
    } else if (isPaused) {
      bgColor = const Color(0xFFFFF3CD);
      textColor = const Color(0xFF856404);
    } else {
      bgColor = const Color(0xFFF2F6FF);
      textColor = const Color(0xFF6C757D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
