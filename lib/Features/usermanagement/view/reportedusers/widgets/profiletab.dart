import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/reportedviewmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/view/reportedusers/widgets/reportsection.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportedUserProfileTab extends StatelessWidget {
  const ReportedUserProfileTab({super.key});

  Widget _buildLeftRow(String label, String value) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: textWidget(
                  text: label,
                  fontweight: FontWeight.w600,
                  fontsize: 13,
                  color: PColors.color042F40),
            ),
            Expanded(
              child: textWidget(text: value, fontsize: 13),
            ),
          ],
        ),
        Divider(color: PColors.color042F40, height: 40),
      ],
    );
  }

  Widget _buildRightColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: label, fontsize: 13, color: PColors.color353534),
        const SizedBox(height: 4),
        textWidget(
          text: value,
          fontsize: 13,
          fontweight: FontWeight.w600,
        ),
        Divider(color: PColors.color353534, height: 20),
      ],
    );
  }

  String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}, ${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return dateStr;
    }
  }

  String formatDOB(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportedViewModel>();
    final user = provider.reportedUser;

    if (user == null) {
      return Center(child: Text('No user data available'));
    }

    return Column(
      children: [
        ReportSection(),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PColors.colorFFFFFF,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                text: "Profile",
                fontweight: FontWeight.w700,
                fontsize: 16,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side
                  Expanded(
                    child: Column(
                      children: [
                        _buildLeftRow("Full Name",
                            user.fullName.isNotEmpty ? user.fullName : "N/A"),
                        _buildLeftRow("Phone",
                            "${user.countryCode} ${user.mobileNumber}"),
                        _buildLeftRow(
                            "Address",
                            user.locationString.isNotEmpty
                                ? user.locationString
                                : "N/A"),
                        _buildLeftRow("Gender",
                            user.gender.isNotEmpty ? user.gender : "N/A"),
                        _buildLeftRow("DOB", formatDOB(user.dateOfBirth)),
                        _buildLeftRow(
                            "Languages",
                            user.otherLanguages.isNotEmpty
                                ? user.otherLanguages.join(', ')
                                : "N/A"),
                        _buildLeftRow("Height",
                            user.height.isNotEmpty ? user.height : "N/A"),
                        _buildLeftRow(
                            "Marital Status",
                            user.relationshipStatus.isNotEmpty
                                ? user.relationshipStatus
                                : "N/A"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right Side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRightColumn(
                            "Last Login", formatDateTime(user.updatedAt)),
                        _buildRightColumn(
                            "Account Created", formatDateTime(user.createdAt)),
                      ],
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
