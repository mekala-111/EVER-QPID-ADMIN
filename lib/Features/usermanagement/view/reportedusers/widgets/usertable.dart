import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/reportedviewmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/view/reportedusers/widgets/userfilter.dart';
import 'package:everqpidadmin/Features/usermanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportedUsersTable extends StatefulWidget {
  const ReportedUsersTable({super.key});

  @override
  State<ReportedUsersTable> createState() => _ReportedUsersTableState();
}

class _ReportedUsersTableState extends State<ReportedUsersTable> {
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
            text: "Reported Users List",
            fontweight: FontWeight.bold,
            color: Colors.black,
            fontsize: 16,
          ),
          const SizedBox(height: 10),

          // Filter Bar
          Consumer<UsersViewModel>(
            builder: (context, viewModel, _) {
              return ReportedUsersFilterBar(
                onSearch: ({
                  required String search,
                  required String status,
                  DateTime? fromDate,
                  DateTime? toDate,
                }) {
                  final viewModel = context.read<UsersViewModel>();
                  viewModel.searchKeyword = search.isNotEmpty ? search : null;
                  viewModel.status = status.isNotEmpty ? status : null;
                  viewModel.fromDate = fromDate;
                  viewModel.toDate = toDate;
                  viewModel.currentPage = 1;
                  viewModel.getReportedUsersFn(context);
                },
                onClear: () {
                  final viewModel = context.read<UsersViewModel>();
                  viewModel.searchKeyword = null;
                  viewModel.status = null;
                  viewModel.fromDate = null;
                  viewModel.toDate = null;
                  viewModel.currentPage = 1;
                  viewModel.getReportedUsersFn(context);
                },
              );
            },
          ),
          const SizedBox(height: 10),

          // Table with loading and error states
          Consumer<UsersViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.reportedLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Check if there's no data
              if (viewModel.reportedUsers.isEmpty) {
                return _buildEmptyState(context, viewModel);
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
                  if (viewModel.reportedUsers.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildPagination(context, viewModel),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// ------------------------ EMPTY STATE ------------------------
  Widget _buildEmptyState(BuildContext context, UsersViewModel viewModel) {
    final hasFilters = viewModel.searchKeyword != null ||
        viewModel.status != null ||
        viewModel.fromDate != null ||
        viewModel.toDate != null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: PColors.color042F40.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters ? Icons.search_off : Icons.people_outline,
                size: 40,
                color: PColors.color042F40.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              hasFilters ? "No Results Found" : "No Reported Users",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: PColors.color353534,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              hasFilters
                  ? "Try adjusting your filters or search terms"
                  : viewModel.reportedError ??
                      "There are no reported users at this time",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            // Clear filters button (only show if filters are active)
            if (hasFilters) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () {
                  viewModel.searchKeyword = null;
                  viewModel.status = null;
                  viewModel.fromDate = null;
                  viewModel.toDate = null;
                  viewModel.currentPage = 1;
                  viewModel.getReportedUsersFn(context);
                },
                icon: const Icon(Icons.clear_all),
                label: const Text("Clear All Filters"),
                style: TextButton.styleFrom(
                  foregroundColor: PColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
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
              ? () => viewModel.prevReportedPage(context)
              : null,
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 16),
        Text(
          'Page ${viewModel.currentPage} of ${viewModel.reportedTotalPages}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: viewModel.currentPage < viewModel.reportedTotalPages
              ? () => viewModel.nextReportedPage(context)
              : null,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  /// ------------------------ TABLE HEADERS ------------------------
  List<DataColumn> _getColumns() {
    return [
      DataColumn(label: _header("User")),
      DataColumn(label: _header("Reported By")),
      DataColumn(label: _header("Reason")),
      DataColumn(label: _header("Warning Level")),
      DataColumn(label: _header("Attempts Left")),
      DataColumn(label: _header("Status")),
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
  /// ------------------------ TABLE ROWS ------------------------
  List<DataRow> _getRows(BuildContext context, UsersViewModel viewModel) {
    return viewModel.reportedUsers.map((report) {
      // Handle null reported user
      final hasReportedUser = report.reported != null;
      final reportedName = hasReportedUser
          ? report.reported!.fullName.toString()
          : "User Deleted";
      final reportedEmail =
          hasReportedUser ? report.reported!.email.toString() : "N/A";

      return DataRow(
        cells: [
          DataCell(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _txt(reportedName),
                Text(
                  reportedEmail,
                  style: TextStyle(
                    fontSize: 10,
                    color: hasReportedUser ? Colors.grey[600] : Colors.red[300],
                    fontStyle:
                        hasReportedUser ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          DataCell(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _txt(report.reporter?.fullName ?? "User Deleted"),
                Text(
                  report.reporter?.email ?? "N/A",
                  style: TextStyle(
                    fontSize: 10,
                    color: report.reporter != null
                        ? Colors.grey[600]
                        : Colors.red[300],
                    fontStyle: report.reporter != null
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          DataCell(_txt(report.reason)),
          DataCell(_WarningLevelChip(level: report.warningLevel)),
          DataCell(_txt(report.attemptsLeft.toString())),
          DataCell(_StatusChip(status: report.status)),
          DataCell(
            SizedBox(
              height: 32,
              child: ElevatedButton(
                // Disable button if reported user is null
                onPressed: hasReportedUser
                    ? () async {
                        await context
                            .read<ReportedViewModel>()
                            .getReportedUserDetailsFn(context,
                                userId: report.reported!.id.toString());

                        if (context.mounted &&
                            context
                                    .read<ReportedViewModel>()
                                    .reportedUserError ==
                                null) {
                          context.read<WrapperViewModel>().updatePageIndex(
                              GetWrapperPageViewStatus.reporteduserDetails);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasReportedUser ? PColors.primaryColor : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  hasReportedUser ? "View" : "Unavailable",
                  style: TextStyle(
                    fontSize: 12,
                    color: hasReportedUser ? Colors.white : Colors.grey[600],
                  ),
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

/// ------------------------ WARNING LEVEL CHIP ------------------------
class _WarningLevelChip extends StatelessWidget {
  final String level;
  const _WarningLevelChip({required this.level});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (level.toLowerCase()) {
      case 'high':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFD32F2F);
        break;
      case 'medium':
        bgColor = const Color(0xFFFFF3CD);
        textColor = const Color(0xFFFF6F00);
        break;
      case 'low':
      default:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// ------------------------ STATUS CHIP ------------------------
class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = const Color(0xFF61DF41);
        textColor = Colors.white;
        break;
      case 'under review':
        bgColor = const Color(0xFFFFF3CD);
        textColor = const Color(0xFF856404);
        break;
      case 'final warning':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFD32F2F);
        break;
      default:
        bgColor = const Color(0xFFF2F6FF);
        textColor = const Color(0xFF6C757D);
        break;
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
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
