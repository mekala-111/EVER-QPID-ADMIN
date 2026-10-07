import 'package:everqpidadmin/Features/Ticketmanagement/view/widgets/ticketfilter.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/ticketdetailsviewmodel.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketTable extends StatefulWidget {
  const TicketTable({super.key});

  @override
  State<TicketTable> createState() => _TicketTableState();
}

class _TicketTableState extends State<TicketTable> {
  @override
  void initState() {
    super.initState();
    // Load employees when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketsViewModel>().getCustomerSupportEmployees(context);
      context.read<TicketsViewModel>().getAllTicketsFn(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar
          Consumer<TicketsViewModel>(
            builder: (context, viewModel, _) {
              return TicketFilterBar(
                onClear: () {
                  viewModel.clearFilters(context);
                },
                onSearch: ({required search, statusFilter, priorityFilter}) {
                  viewModel.applyFilters(
                    context,
                    search: search,
                    statusFilter: statusFilter,
                    priorityFilter: priorityFilter,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Table with loading and error states
          Consumer<TicketsViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Show empty state when no tickets
              if (viewModel.tickets.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(60),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        viewModel.error ?? "No tickets found",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try adjusting your filters or search criteria",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Table with data
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DataTable(
                      showCheckboxColumn: false,
                      dividerThickness: 0,
                      dataRowColor: WidgetStateProperty.all(Colors.transparent),
                      columnSpacing: 12,
                      horizontalMargin: 16,
                      columns: _getColumns(),
                      rows: _getRows(context, viewModel),
                    ),
                  ),

                  // Pagination
                  if (viewModel.tickets.isNotEmpty) ...[
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

  /// ------------------------ PAGINATION ------------------------
  Widget _buildPagination(BuildContext context, TicketsViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: viewModel.currentPage > 1
              ? () => viewModel.prevPage(context)
              : null,
          icon: const Icon(Icons.arrow_back),
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
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  /// ------------------------ TABLE HEADERS ------------------------
  List<DataColumn> _getColumns() {
    return [
      DataColumn(label: Expanded(child: _header("ID"))),
      DataColumn(label: Expanded(child: _header("User"))),
      DataColumn(label: Expanded(child: _header("Category"))),
      DataColumn(label: Expanded(child: _header("Subject"))),
      DataColumn(label: Expanded(child: _header("Priority"))),
      DataColumn(label: Expanded(child: _header("Created"))),
      DataColumn(label: Expanded(child: _header("Status"))),
      DataColumn(label: Expanded(child: _header("Assigned"))),
      DataColumn(label: Expanded(child: _header("Action"))),
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
  List<DataRow> _getRows(BuildContext context, TicketsViewModel viewModel) {
    return viewModel.tickets.map((ticket) {
      // Format user display
      String userDisplay = ticket.userId?.email ?? ticket.email;
      if (ticket.firstName != null && ticket.firstName!.isNotEmpty) {
        userDisplay = ticket.firstName!;
      }

      // Format date
      String createdDate = ticket.createdAt.toString().split(' ')[0];

      // Status
      String status = ticket.status;

      return DataRow(
        cells: [
          DataCell(_txt(ticket.ticketId, maxWidth: 170)),
          DataCell(_txt(userDisplay, maxWidth: 100)),
          DataCell(_txt(ticket.category, maxWidth: 100)),
          DataCell(
            _txt(
              ticket.subject.length > 25
                  ? '${ticket.subject.substring(0, 25)}...'
                  : ticket.subject,
              maxWidth: 150,
            ),
          ),
          DataCell(_PriorityChip(priority: ticket.priority)),
          DataCell(_txt(createdDate, maxWidth: 90)),
          DataCell(_StatusChip(status: status)),
          DataCell(
            ticket.assignedTo != null
                ? _txt(ticket.assignedTo!.name, maxWidth: 100)
                : _AssignButton(
                    ticketId: ticket.ticketId,
                    employees: viewModel.employees,
                  ),
          ),
          DataCell(
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () {
                  final ticketId = ticket.ticketId;
                  final userId = ticket.userId?.id;

                  // Guest ticket → allow navigation but SKIP user actions
                  context.read<TicketDetailsViewModel>().tcketId = ticketId;
                  context.read<TicketsViewModel>().ticketId = ticketId;

                  if (userId != null) {
                    context.read<TicketsViewModel>().userId = userId;
                    context.read<TicketDetailsViewModel>().getUserNotesFn(
                          context,
                          userId: userId,
                        );
                  }

                  context.read<WrapperViewModel>().updatePageIndex(
                        GetWrapperPageViewStatus.ticketDetails,
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _txt(String text, {double? maxWidth}) {
    Widget textWidget = Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: PColors.color353534,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    if (maxWidth != null) {
      return SizedBox(
        width: maxWidth,
        child: textWidget,
      );
    }
    return textWidget;
  }
}

/// ------------------------ STATUS CHIP ------------------------
class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status.toLowerCase() == "open";

    Color bgColor = isOpen ? const Color(0xFFFFF3CD) : const Color(0xFF61DF41);
    Color textColor = isOpen ? const Color(0xFF856404) : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// ------------------------ PRIORITY CHIP ------------------------
class _PriorityChip extends StatelessWidget {
  final String priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (priority.toLowerCase()) {
      case 'high':
        bgColor = const Color(0xFFFFE5E5);
        textColor = const Color(0xFFD32F2F);
        break;
      case 'medium':
        bgColor = const Color(0xFFFFF3CD);
        textColor = const Color(0xFF856404);
        break;
      case 'low':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      default:
        bgColor = const Color(0xFFF2F6FF);
        textColor = const Color(0xFF6C757D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// ------------------------ ASSIGN BUTTON ------------------------
class _AssignButton extends StatelessWidget {
  final String ticketId;
  final List employees;

  const _AssignButton({
    required this.ticketId,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () {
          _showAssignDialog(context, ticketId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007BFF),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          "Assign",
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }

  void _showAssignDialog(BuildContext context, String ticketId) {
    String? selectedEmployeeId;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Assign Ticket'),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Employee',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    employees.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'No employees available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            initialValue: selectedEmployeeId,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              hintText: 'Choose an employee',
                            ),
                            items: employees.map((employee) {
                              return DropdownMenuItem<String>(
                                value: employee.id,
                                child: Text(
                                  employee.name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedEmployeeId = value;
                              });
                            },
                          ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: employees.isEmpty
                      ? null
                      : () async {
                          if (selectedEmployeeId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an employee'),
                              ),
                            );
                            return;
                          }

                          // Call assign ticket API
                          await context.read<TicketsViewModel>().assignTicket(
                                context,
                                ticketId: ticketId,
                                assigneeName: selectedEmployeeId!,
                              );

                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                  ),
                  child: const Text('Assign'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
