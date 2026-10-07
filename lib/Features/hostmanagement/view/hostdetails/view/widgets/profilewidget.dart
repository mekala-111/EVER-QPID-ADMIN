import 'package:everqpidadmin/Features/hostmanagement/viewmodel/hostdetailsviewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HostProfileTab extends StatelessWidget {
  const HostProfileTab({super.key});

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
                  color: Colors.black54),
            ),
            Expanded(
              child: textWidget(text: value, fontsize: 13),
            ),
          ],
        ),
        Divider(color: Colors.blueGrey, height: 40),
      ],
    );
  }

  Widget _buildRightColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: label, fontsize: 13, color: Colors.black54),
        const SizedBox(height: 4),
        textWidget(
          text: value,
          fontsize: 13,
          fontweight: FontWeight.w600,
        ),
        Divider(color: Colors.blueGrey, height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Hostdetailsviewmodel>(
      builder: (context, viewmodel, child) {
        // Handle loading state
        if (viewmodel.hostDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (viewmodel.hostDetailsError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  viewmodel.hostDetailsError!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Handle null userProfile
        if (viewmodel.hostDetails == null) {
          return const Center(
            child: Text('No user profile data available'),
          );
        }

        // Access userProfile safely now
        final profile = viewmodel.hostDetails!;

        return Column(
          children: [
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
                      // Left Side
                      Expanded(
                        child: Column(
                          children: [
                            _buildLeftRow(
                                "Full Name", profile.data.userProfile.fullName),
                            _buildLeftRow(
                                "Phone", profile.data.userProfile.mobileNumber),
                            _buildLeftRow(
                                "Gender", profile.data.userProfile.gender),
                            _buildLeftRow(
                              "DOB",
                              _formatDate(profile.data.userProfile.dateOfBirth),
                            ),
                            // ❌ REMOVE THIS DUPLICATE LINE:
                            // _buildLeftRow(
                            //   "DOB",
                            //   "${profile.data.userProfile.dateOfBirth}",
                            // ),
                            _buildLeftRow(
                              "Languages",
                              profile.data.userProfile.otherLanguages.isNotEmpty
                                  ? profile.data.userProfile.otherLanguages
                                      .join(", ")
                                  : "Not specified",
                            ),
                            _buildLeftRow("Height",
                                "${profile.data.userProfile.height} cm"),
                            _buildLeftRow(
                              "Marital Status",
                              profile.data.userProfile.relationshipStatus
                                      .isNotEmpty
                                  ? profile.data.userProfile.relationshipStatus
                                  : "Not specified",
                            ),
                            _buildLeftRow(
                                "Religion",
                                profile.data.userProfile.religion.isNotEmpty
                                    ? profile.data.userProfile.religion
                                    : "Not specified"),
                            _buildLeftRow(
                              "Interests",
                              profile.data.userProfile.interests.isNotEmpty
                                  ? profile.data.userProfile.interests
                                      .where((i) => i.isNotEmpty)
                                      .join(", ")
                                  : "Not specified",
                            ),
                            _buildLeftRow(
                                "Address",
                                profile.data.userProfile.locationString
                                        .isNotEmpty
                                    ? profile.data.userProfile.locationString
                                    : "Not specified"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right Side
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // _buildRightColumn(
                            //   "Last Login",
                            //   profile.data.userProfile.ac != null
                            //       ? profile.data.userProfile.lastActive.toString()
                            //       : "Never",
                            // ),
                            _buildRightColumn(
                              "Created At",
                              formatDate(profile.data.userProfile.createdAt
                                  .toString()),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                    text: "Work & Education",
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
                            _buildLeftRow(
                              "Profession",
                              profile.data.userProfile.currentProfession,
                            ),
                            _buildLeftRow("Company",
                                profile.data.userProfile.companyName),
                            _buildLeftRow("Type",
                                profile.data.userProfile.employmentType),
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
                                "Course", profile.data.userProfile.education),
                            _buildRightColumn("University",
                                profile.data.userProfile.collegeName),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dateTime); // 01/01/2000
      // return DateFormat('d MMM yyyy').format(dateTime);   // 1 Jan 2000
      // return DateFormat('MMMM d, yyyy').format(dateTime); // January 1, 2000
    } catch (e) {
      return 'Invalid date';
    }
  }
}
