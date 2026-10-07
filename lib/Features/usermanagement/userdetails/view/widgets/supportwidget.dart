import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupportTicketsCard extends StatelessWidget {
  const SupportTicketsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserDetailsViewModel>();

    Color priorityColor(String priority) {
      switch (priority.toLowerCase()) {
        case "high":
          return Colors.red;
        case "medium":
          return Colors.orange;
        case "low":
          return Colors.black;
        default:
          return Colors.grey;
      }
    }

    Color statusColor(String status) {
      switch (status.toLowerCase()) {
        case "open":
          return Colors.green;
        case "closed":
          return Colors.grey;
        default:
          return Colors.grey;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Support Tickets",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _tableHeader(),
          const Divider(height: 24),
          if (vm.ticketsLoading)
            const Center(child: CircularProgressIndicator())
          else if (vm.tickets.isEmpty)
            const Center(child: Text("No tickets found"))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.tickets.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final ticket = vm.tickets[index];
                return _tableRow(
                  ticket: ticket.ticketId,
                  created: _formatDate(ticket.createdAt),
                  issue: ticket.reason,
                  priority: ticket.priority,
                  status: ticket.status,
                  priorityColor: priorityColor(ticket.priority),
                  statusColor: statusColor(ticket.status),
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(flex: 2, child: Text("Ticket", style: _headerStyle)),
        Expanded(flex: 3, child: Text("Created", style: _headerStyle)),
        Expanded(flex: 3, child: Text("Issue", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Priority", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Status", style: _headerStyle)),
      ],
    );
  }

  Widget _tableRow({
    required String ticket,
    required String created,
    required String issue,
    required String priority,
    required String status,
    required Color priorityColor,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(ticket)),
        Expanded(flex: 3, child: Text(created)),
        Expanded(flex: 3, child: Text(issue)),
        Expanded(
          flex: 2,
          child: Text(priority,
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: priorityColor)),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 13,
  color: Colors.grey,
  fontWeight: FontWeight.w500,
);
