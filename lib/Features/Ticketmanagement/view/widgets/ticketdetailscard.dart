import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/ticketdetailsviewmodel.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TicketDetailsCard extends StatelessWidget {
  const TicketDetailsCard({super.key});

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'N/A';
      }
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'closed':
        return Colors.green;
      case 'pending':
        return Colors.blue;
      case 'resolved':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Widget _rowItem(String title, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff7A869A),
            ),
          ),
          const SizedBox(height: 6),
          value,
          const Divider(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TicketDetailsViewModel>();

    // Show loading state
    // if (provider.loading && provider.ticket == null) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    // Show error state
    if (provider.error != null && provider.ticket == null) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Error: ${provider.error}',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    final ticket = provider.ticket;
    final isClosed = context.watch<TicketDetailsViewModel>().isClosed;

    // Show no data state
    if (ticket == null) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No ticket data available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        /// -------- Ticket Details --------

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ticket Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT COLUMN
                  Expanded(
                    child: Column(
                      children: [
                        _rowItem(
                          'Email',
                          Text(
                            ticket.email,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        _rowItem(
                          'Category',
                          Text(
                            ticket.category,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        _rowItem(
                          'Subject',
                          Text(
                            ticket.subject,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        _rowItem(
                          'Priority',
                          Text(
                            ticket.priority.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              color: _getPriorityColor(ticket.priority),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _rowItem(
                          'Created On',
                          Text(
                            _formatDate(ticket.createdAt),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        _rowItem(
                          'Status',
                          Text(
                            ticket.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              color: _getStatusColor(ticket.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  /// RIGHT COLUMN
                  Expanded(
                    child: Column(
                      children: [
                        _rowItem(
                          'Description',
                          Text(
                            ticket.description,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        _rowItem(
                          'Attachments',
                          ticket.attachments.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...ticket.attachments.map(
                                      (attachment) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.attach_file,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                attachment.toString(),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff9B5DE5),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: null,
                                      child: const Text('View All'),
                                    ),
                                  ],
                                )
                              : Text(
                                  'No attachments',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// -------- Admin Actions --------
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Admin Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isClosed ? Colors.grey : const Color(0xff9B5DE5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isClosed
                        ? null
                        : () {
                            context
                                .read<TicketsViewModel>()
                                .closeTicket(context);
                          },
                    child: Text(
                      isClosed ? 'Ticket Closed' : 'Close Ticket',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      context.read<TicketsViewModel>().cancelTicket(context);
                    },
                    child: const Text(
                      'Cancel Ticket',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
