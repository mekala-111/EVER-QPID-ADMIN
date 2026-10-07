import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserProfileTab extends StatelessWidget {
  const UserProfileTab({super.key});

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
    return Consumer<UserDetailsViewModel>(
      builder: (context, viewmodel, child) {
        // Handle loading state
        if (viewmodel.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (viewmodel.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  viewmodel.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Handle null userProfile
        if (viewmodel.userProfile == null) {
          return const Center(
            child: Text('No user profile data available'),
          );
        }

        // Access userProfile safely now
        final profile = viewmodel.userProfile!;

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
                      Expanded(
                        child: Column(
                          children: [
                            _buildLeftRow("Full Name", profile.fullName),
                            _buildLeftRow("Phone", profile.mobileNumber),
                            _buildLeftRow("Gender", profile.gender),
                            _buildLeftRow(
                              "DOB",
                              "${profile.dateOfBirth!.day}/${profile.dateOfBirth!.month}/${profile.dateOfBirth!.year}",
                            ),
                            _buildLeftRow(
                              "Languages",
                              profile.otherLanguages.isNotEmpty
                                  ? profile.otherLanguages.join(", ")
                                  : "Not specified",
                            ),
                            _buildLeftRow("Height", profile.height.toString()),
                            _buildLeftRow(
                              "Marital Status",
                              profile.relationshipStatus,
                            ),
                            _buildLeftRow("Religion", profile.religion),
                            _buildLeftRow(
                              "Interests",
                              profile.interests.isNotEmpty
                                  ? profile.interests.join(", ")
                                  : "Not specified",
                            ),
                            _buildLeftRow("Address", profile.locationString),
                            _buildLeftRow("Zodiac Sign", profile.zodiacSign),
                            _buildLeftRow(
                                "Smoking Habit", profile.smokingHabit),
                            _buildLeftRow(
                                "Workout Frequency", profile.workoutFrequency),
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
                              "Last Login",
                              formatDateTime(profile.lastActive),
                            ),
                            _buildRightColumn("Created At",
                                formatDateTime(profile.createdAt)),
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
                              profile.currentProfession,
                            ),
                            _buildLeftRow("Company", profile.companyName),
                            _buildLeftRow("Type", profile.employmentType),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right Side
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRightColumn("Course", profile.education),
                            _buildRightColumn(
                                "University", profile.collegeName),
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

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Never";
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime.toLocal());
  }
}
