import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/reportedviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportSection extends StatelessWidget {
  const ReportSection({super.key});

  String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final hour =
          date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}, ${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return dateStr;
    }
  }

  Color getWarningColor(String warningLevel) {
    switch (warningLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String getAccountStatus(List reports) {
    if (reports.isEmpty) return "Active";
    final hasOpenReport = reports.any((r) =>
        r.status.toLowerCase() == 'open' ||
        r.status.toLowerCase() == 'pending');
    return hasOpenReport ? "Under Review" : "Active";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportedViewModel>();
    final reports = provider.reports;

    // Calculate warning level based on reports
    String warningLevel = "Low";
    if (reports.isNotEmpty) {
      // Use the highest warning level from reports
      final levels = reports.map((r) => r.warningLevel).toList();
      if (levels.any((l) => l.toLowerCase() == 'high')) {
        warningLevel = "High";
      } else if (levels.any((l) => l.toLowerCase() == 'medium')) {
        warningLevel = "Medium";
      }
    }

    // Get attempts left from first report (if available)
    int attemptsLeft = reports.isNotEmpty ? reports.first.attemptsLeft : 3;

    final accountStatus = getAccountStatus(reports);
    final warningColor = getWarningColor(warningLevel);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          const Text(
            "Report",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          /// Top Status Row
          Row(
            children: [
              _infoColumn(
                title: "Account Status:",
                value: accountStatus,
                valueColor: accountStatus == "Under Review"
                    ? Colors.orange
                    : Colors.green,
              ),
              _divider(),
              _infoColumn(
                title: "Warning Level",
                chipText: warningLevel,
                chipColor: warningColor.withValues(alpha: 0.2),
                textColor: warningColor,
              ),
              _divider(),
              _infoColumn(
                title: "Attempts Left",
                subtitle:
                    "$attemptsLeft Attempts Left - Profile will be suspended if violations continue.",
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Report History
          const Text(
            "Report History",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          /// Show message if no reports
          if (reports.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "No reports found",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else ...[
            /// Table Header
            _tableHeader(),
            const Divider(),

            /// Table Rows
            ...reports.map(
              (report) => Column(
                children: [
                  _tableRow(
                    date: formatDateTime(report.createdAt),
                    name: report.reporter.fullName.isNotEmpty
                        ? report.reporter.fullName
                        : report.reporter.email,
                    detail: report.reason.isNotEmpty
                        ? report.reason
                        : "No reason provided",
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          /// Action Buttons
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: null,
                child: const Text(
                  "Reset Warnings",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: null,
                child: const Text(
                  "Suspend Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Widgets

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey.shade300,
    );
  }

  Widget _infoColumn({
    required String title,
    String? value,
    Color? valueColor,
    String? subtitle,
    String? chipText,
    Color? chipColor,
    Color? textColor,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          if (value != null)
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          if (chipText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: chipColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                chipText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 3,
          child: Text(
            "Date",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "Reported By",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            "Details",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _tableRow({
    required String date,
    required String name,
    required String detail,
  }) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(date)),
        Expanded(flex: 2, child: Text(name)),
        Expanded(flex: 4, child: Text(detail)),
      ],
    );
  }
}
