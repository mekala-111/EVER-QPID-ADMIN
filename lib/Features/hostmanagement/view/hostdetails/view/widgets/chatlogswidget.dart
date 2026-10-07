import 'package:everqpidadmin/Features/hostmanagement/viewmodel/hostdetailsviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostChatLogsCard extends StatelessWidget {
  const HostChatLogsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Hostdetailsviewmodel>(
      builder: (context, vm, _) {
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
              /// Title
              const Text(
                "Chat Logs",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Loading state
              if (vm.chatLogsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              // Empty state
              else if (vm.chatLogs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No chat logs found",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Chat logs will appear here once users start conversations",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              // Data state
              else
                Column(
                  children: [
                    /// Header
                    _tableHeader(),

                    const Divider(height: 24),

                    /// Rows
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.chatLogs.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (context, index) {
                        final item = vm.chatLogs[index];

                        return _tableRow(
                          user: item.fullName,
                          started: "-", // API not giving date yet
                          count: item.chatCount.toString(),
                          status: item.status ? "Active" : "Inactive",
                          statusColor: item.status ? Colors.green : Colors.grey,
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  /// Header Row
  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(flex: 3, child: Text("User Name", style: _headerStyle)),
        // Expanded(flex: 3, child: Text("Chat Started", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Chat Count", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Status", style: _headerStyle)),
      ],
    );
  }

  /// Single Row
  Widget _tableRow({
    required String user,
    required String started,
    required String count,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            user,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(flex: 3, child: Text(started)),
        Expanded(
          flex: 2,
          child: Text(
            count,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
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
