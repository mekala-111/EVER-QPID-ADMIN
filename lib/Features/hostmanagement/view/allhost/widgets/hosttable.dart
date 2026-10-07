import 'package:everqpidadmin/Features/hostmanagement/view/allhost/widgets/hostfilter.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/hostdetailsviewmodel.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostTable extends StatefulWidget {
  const HostTable({super.key});

  @override
  State<HostTable> createState() => _HostTableState();
}

class _HostTableState extends State<HostTable> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size / 1.3;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar
          Consumer<HostmanagementViewmodel>(
            builder: (context, viewModel, _) {
              return HostFilterBar(
                onClear: () {
                  viewModel.clearFilters(context);
                  viewModel.getAllHostsFn(context);
                },
                onSearch: ({fromDate, required search, toDate}) {
                  viewModel.searchKeyword = search.isEmpty ? null : search;
                  viewModel.fromDate = fromDate;
                  viewModel.toDate = toDate;
                  viewModel.currentPage = 1;
                  viewModel.getAllHostsFn(context);
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Table with loading and error states
          Consumer<HostmanagementViewmodel>(
            builder: (context, viewModel, _) {
              if (viewModel.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Show centered no data design when list is empty
              if (viewModel.hostList.isEmpty) {
                return _buildNoDataView(viewModel.error);
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
                  if (viewModel.hostList.isNotEmpty) ...[
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

  /// ------------------------ NO DATA VIEW ------------------------
  Widget _buildNoDataView(String? errorMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: PColors.color042F40.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 64,
              color: PColors.color042F40.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          textWidget(
            text: errorMessage ?? "No Hosts Found",
            fontsize: 18,
            fontweight: FontWeight.w600,
            color: PColors.color353534,
          ),
          const SizedBox(height: 8),

          // Description
          textWidget(
            text: errorMessage != null
                ? "There was an error loading the data"
                : "No host profiles available at the moment",
            fontsize: 14,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),

          // Optional: Retry button (if there's an error)
          if (errorMessage != null)
            ElevatedButton.icon(
              onPressed: () {
                context.read<HostmanagementViewmodel>().getAllHostsFn(context);
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: PColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ------------------------ PAGINATION ------------------------
  Widget _buildPagination(
      BuildContext context, HostmanagementViewmodel viewModel) {
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
      DataColumn(label: _header("Language")),
      DataColumn(label: _header("Age")),
      DataColumn(label: _header("Location")),
      DataColumn(label: _header("Status")),
      DataColumn(label: _header("Created Date")),
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
  List<DataRow> _getRows(
      BuildContext context, HostmanagementViewmodel viewModel) {
    return viewModel.hostList.map((host) {
      // Format status
      String status = host.isActive ? "Active" : "Inactive";
      if (host.isPaused) status = "Paused";

      // Format languages - join with commas
      String languages = host.otherLanguages.isNotEmpty
          ? host.otherLanguages.join(", ")
          : "N/A";

      // Format date - show only date part
      String createdDate =
          host.createdAt.isNotEmpty ? host.createdAt.split('T')[0] : "N/A";

      return DataRow(
        cells: [
          DataCell(_txt(host.fullName)),
          DataCell(_txt(languages)),
          DataCell(_txt(host.age.toString())),
          DataCell(_txt(host.locationString)),
          DataCell(_StatusChip(status: status)),
          DataCell(_txt(createdDate)),
          DataCell(
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () async {
                  final vm = context.read<Hostdetailsviewmodel>();

                  vm.userId = host.id.toString();

                  // IMPORTANT: Load host details FIRST and wait for it
                  await vm.getHostDetailsFn(context, hostId: host.id);

                  if (!context.mounted) return;

                  // Check if host details loaded successfully
                  if (vm.hostDetails == null) {
                    // Don't navigate if host details failed to load
                    return;
                  }

                  // Initialize host management with the host data
                  context
                      .read<HostmanagementViewmodel>()
                      .initializeForEdit(host);

                  // Navigate BEFORE loading other data
                  context.read<WrapperViewModel>().updatePageIndex(
                        GetWrapperPageViewStatus.hostDetails,
                      );

                  // Load other data in background AFTER navigation (non-blocking)
                  // Wrapped in Future.microtask to prevent blocking
                  Future.microtask(() {
                    if (context.mounted) {
                      vm.getHostPhotosFn(context, userId: host.id.toString());
                    }
                  });

                  Future.microtask(() {
                    if (context.mounted) {
                      vm.getHostMatchesFn(context, userId: host.id.toString());
                    }
                  });

                  Future.microtask(() {
                    if (context.mounted) {
                      vm.getChatLogsFn(context, userId: host.id.toString());
                    }
                  });

                  Future.microtask(() {
                    if (context.mounted) {
                      vm.getHostSentLikesFn(
                        context,
                        hostId: host.id.toString(),
                        pageNumber: 1,
                        pageSize: 10000,
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 35),
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
