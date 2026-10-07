import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/reportedviewmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/view/reportedusers/widgets/profiletab.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../Settings/utils/p_colors.dart';

class ReportedUserDetailsScreen extends StatefulWidget {
  const ReportedUserDetailsScreen({super.key});

  @override
  State<ReportedUserDetailsScreen> createState() =>
      _ReportedUserDetailsScreenState();
}

class _ReportedUserDetailsScreenState extends State<ReportedUserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.scaffoldColor2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
                text: "User Details",
                fontweight: FontWeight.w700,
                fontsize: 20),
            const SizedBox(height: 8),
            textWidget(
                text: "Admin / User Management / John Doe",
                fontsize: 12,
                color: Colors.grey),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SIDE – USER CARD & NOTES
                Expanded(flex: 2, child: _buildLeftSide(context)),

                const SizedBox(width: 20),

                /// RIGHT SIDE – TAB CONTENT
                Expanded(flex: 4, child: _buildRightSide(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSide(BuildContext context) {
    final provider = context.watch<ReportedViewModel>();

    // Show loading only if loading AND no existing data
    if (provider.reportedUserLoading && provider.reportedSideProfile == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.reportedUserError != null) {
      return Center(child: Text('Error: ${provider.reportedUserError}'));
    }

    final sideProfile = provider.reportedSideProfile;

    if (sideProfile == null) {
      return Center(child: Text('No data available'));
    }

    // ... rest of your code

    // Format dates
    String formatDate(DateTime? date) {
      if (date == null) return 'N/A';
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
    }

    String formatJoinedDate(DateTime? date) {
      if (date == null) return 'N/A';
      const months = [
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
      return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
    }

    String formatLastActive(dynamic lastActive) {
      if (lastActive == null) return 'N/A';
      if (lastActive is String) {
        final date = DateTime.tryParse(lastActive);
        if (date != null) {
          return '${formatJoinedDate(date).split(',')[0]}, ${date.year}';
        }
      }
      return 'N/A';
    }

    return Column(
      children: [
        /// User Info Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PColors.colorFFFFFF,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PColors.color042F40),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.amber,
                    backgroundImage: null, // Add image if available
                    child: Text(
                      sideProfile.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          textWidget(
                            text: sideProfile.fullName,
                            fontweight: FontWeight.w600,
                            fontsize: 16,
                          ),
                          if (sideProfile.isVerified == true) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      textWidget(
                        text: "Joined ${formatJoinedDate(
                          DateTime.tryParse(sideProfile.joinedDate),
                        )}",
                        fontsize: 12,
                        color: Colors.grey,
                      ),
                      textWidget(
                        text:
                            "Last active ${formatLastActive(sideProfile.lastActive)}",
                        fontsize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        text: "Phone No.",
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: PColors.color000000,
                      ),
                      textWidget(
                        text: sideProfile.phoneNo,
                        fontsize: 13,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        text: "Verification.",
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: PColors.color000000,
                      ),
                      textWidget(
                          text: sideProfile.isVerified == true
                              ? 'Verified'
                              : 'Pending',
                          fontsize: 13,
                          color: sideProfile.isVerified == true
                              ? Colors.green
                              : Colors.orangeAccent),
                      const SizedBox(height: 8),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        text: "Email",
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: PColors.color042F40,
                      ),
                      textWidget(
                        text: sideProfile.email,
                        fontsize: 13,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        text: "Subscription.",
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: PColors.color000000,
                      ),
                      textWidget(
                          text: sideProfile.isSubscribed == true
                              ? 'Subscribed'
                              : 'Pending',
                          fontsize: 13,
                          color: sideProfile.isVerified == true
                              ? Colors.green
                              : Colors.orangeAccent),
                      const SizedBox(height: 8),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _smallInfoCard(
                    "Total Matches",
                    sideProfile.totalMatches.toString(),
                    sideProfile.isSubscribed == true
                        ? "Subscribed"
                        : "Lifetime",
                  ),
                  _smallInfoCard(
                    "Total Spend",
                    "₹${sideProfile.totalSpend}",
                    "Lifetime",
                  ),
                  _smallInfoCard(
                    "Open Tickets",
                    sideProfile.openTickets.toString(),
                    sideProfile.openTickets > 0 ? "High Priority" : "None",
                  ),
                  _smallInfoCard(
                    "Last Chat",
                    formatDate(DateTime.tryParse(sideProfile.lastChatOn)),
                    "Recent",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Send Message",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Deactivate",
                        style: TextStyle(color: PColors.color042F40),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// Internal Notes
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PColors.colorFFFFFF,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PColors.color042F40),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textWidget(
                    text: "Internal Notes",
                    fontweight: FontWeight.w600,
                    fontsize: 14,
                  ),
                  textWidget(
                    text: "Private",
                    fontsize: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _noteItem(
                "Admin",
                "Credit refund issued",
                "",
                "Follow up before Aug 15",
              ),
              const Divider(height: 24),
              _noteItem(
                "Admin",
                "Credit refund issued",
                "",
                "Refund ID #RF2234",
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Add a private note...",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: PColors.color042F40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PColors.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
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

  Widget _buildRightSide(BuildContext context) {
    // return Column(
    //   children: [
    //     Container(
    //       child: Row(
    //         children: [
    //           _tabButton("Profile", 0),
    //           // _tabButton("Bookings", 1),
    //           // _tabButton("Support", 2),
    //         ],
    //       ),
    //     ),
    //     const SizedBox(height: 16),
    //     if (_selectedTab == 0) const ReportedUserProfileTab(),
    //     // if (_selectedTab == 1) const UserBookingsTab(),
    //     // if (_selectedTab == 2) SupportTab()
    //   ],
    // );

    return Column(
      children: [ReportedUserProfileTab()],
    );
  }

  Widget _smallInfoCard(String title, String value, String subtitle) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x1A090808),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(text: title, fontsize: 11, color: Colors.grey),
          textWidget(text: value, fontsize: 13, fontweight: FontWeight.w600),
          textWidget(text: subtitle, fontsize: 11, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _noteItem(String by, String title, String date, String? subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: by, fontweight: FontWeight.w600, fontsize: 13),
        textWidget(text: title, fontsize: 13),
        if (subtitle != null)
          textWidget(text: subtitle, fontsize: 11, color: Colors.grey),
        textWidget(text: date, fontsize: 11, color: Colors.grey),
      ],
    );
  }
}
