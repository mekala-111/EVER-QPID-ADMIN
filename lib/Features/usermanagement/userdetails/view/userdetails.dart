import 'package:everqpidadmin/Features/usermanagement/userdetails/view/widgets/chatlogswidget.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/view/widgets/matcheprofilewidget.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/view/widgets/photosection.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/view/widgets/profilewidget.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/view/widgets/supportwidget.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/view/widgets/transactionwidget.dart';
import 'package:everqpidadmin/Features/usermanagement/userdetails/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/usermanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../Settings/utils/p_colors.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  int _selectedTab = 0;

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
    // Access your provider to get sideProfileDetails
    final provider =
        context.watch<UserDetailsViewModel>(); // or however you access it
    final sideProfile = provider.sideProfileDetails;

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

    String formatDateTime(DateTime? dateTime) {
      if (dateTime == null) return '';

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
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
                    backgroundImage: sideProfile?.fullName != null
                        ? null
                        : null, // Add image if available
                    child: sideProfile?.fullName != null
                        ? Text(
                            sideProfile!.fullName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          textWidget(
                            text: sideProfile?.fullName ?? "Loading...",
                            fontweight: FontWeight.w600,
                            fontsize: 16,
                          ),
                          if (sideProfile?.isVerified == true) ...[
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
                        text:
                            "Joined ${formatJoinedDate(sideProfile?.joinedDate)}",
                        fontsize: 12,
                        color: Colors.grey,
                      ),
                      textWidget(
                        text:
                            "Last active ${formatLastActive(sideProfile?.lastActive)}",
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
                        text: sideProfile?.phoneNo ?? "N/A",
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
                          text: sideProfile?.isVerified == true
                              ? 'Verified'
                              : 'Pending',
                          fontsize: 13,
                          color: sideProfile?.isVerified == true
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
                        text: sideProfile?.email ?? "N/A",
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
                          text: sideProfile?.isSubscribed == true
                              ? 'Subscribed'
                              : 'Pending',
                          fontsize: 13,
                          color: sideProfile?.isVerified == true
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
                    sideProfile?.totalMatches.toString() ?? "0",
                    sideProfile?.isSubscribed == true
                        ? "Subscribed"
                        : "Lifetime",
                  ),
                  _smallInfoCard(
                    "Total Spend",
                    "₹${sideProfile?.totalSpend ?? 0}",
                    "Lifetime",
                  ),
                  _smallInfoCard(
                    "Open Tickets",
                    sideProfile?.openTickets.toString() ?? "0",
                    sideProfile?.openTickets != null &&
                            sideProfile!.openTickets > 0
                        ? "High Priority"
                        : "None",
                  ),
                  _smallInfoCard(
                    "Last Chat",
                    sideProfile?.lastChatOn != null
                        ? formatDate(sideProfile!.lastChatOn is String
                            ? DateTime.tryParse(
                                sideProfile.lastChatOn.toString())
                            : sideProfile.lastChatOn)
                        : "N/A",
                    "Recent",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showSendMessageDialog(
                          context,
                        );
                      },
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
                  // Replace the OutlinedButton section in _buildLeftSide with this corrected code:

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final isActive = provider.userProfile!.isActive;

                        if (isActive) {
                          // User is currently active, so deactivate
                          context.read<UsersViewModel>().deActivateUserFn(
                                context,
                                userId: context
                                    .read<UserDetailsViewModel>()
                                    .userId
                                    .toString(),
                              );
                        } else {
                          // User is currently inactive, so activate
                          context.read<UsersViewModel>().activateUserFn(
                                context,
                                userId: context
                                    .read<UserDetailsViewModel>()
                                    .userId
                                    .toString(),
                              );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(
                          color: provider.userProfile!.isActive
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      child: Text(
                        provider.userProfile!.isActive
                            ? "Deactivate"
                            : "Activate",
                        style: TextStyle(
                          color: provider.userProfile!.isActive
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// Internal Notes - IMPLEMENTED WITH API INTEGRATION
        _buildNotesSection(context, provider, formatDateTime),
      ],
    );
  }

  void _showSendMessageDialog(BuildContext context) {
    // if (userId == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('User ID not available'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }

    final TextEditingController messageController = TextEditingController();
    final provider = context.read<UserDetailsViewModel>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Send Message'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                text: 'Enter your message:',
                fontsize: 13,
                color: Colors.grey[700],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
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
            onPressed: () async {
              final message = messageController.text.trim();

              if (message.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a message'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              Navigator.pop(dialogContext);

              // Call the send message function
              await provider.sentMessage(
                context,
                userId: provider.userId.toString(),
                content: message,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.primaryColor,
            ),
            child: const Text(
              'Send',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, UserDetailsViewModel provider,
      String Function(DateTime?) formatDateTime) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PColors.colorFFFFFF,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PColors.color042F40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget(
                text: "Internal Notes",
                fontweight: FontWeight.w600,
                fontsize: 14,
              ),
              Row(
                children: [
                  textWidget(
                    text: "Private",
                    fontsize: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () {
                      if (provider.userId != null) {
                        provider.getUserNotesFn(context,
                            userId: provider.userId!);
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Loading State
          if (provider.notesLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ),

          // Error State
          if (!provider.notesLoading && provider.notesError != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    textWidget(
                      text: provider.notesError!,
                      color: Colors.red,
                      fontsize: 12,
                    ),
                  ],
                ),
              ),
            ),

          // Notes Content
          if (!provider.notesLoading && provider.notesError == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display existing notes
                if (provider.notesData?.notes != null &&
                    provider.notesData!.notes!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F9FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.person,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            textWidget(
                              text: "Admin",
                              fontweight: FontWeight.w600,
                              fontsize: 13,
                            ),
                            // const Spacer(),
                            // textWidget(
                            //   text: _formatTimeAgo(
                            //     provider.notesData!.updatedAt,
                            //   ),
                            //   fontsize: 11,
                            //   color: Colors.grey,
                            // ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        /// 🔹 Show each note
                        ...provider.notesData!.notes!.map(
                          (note) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: textWidget(
                                    text: note.note ?? '',
                                    fontsize: 13,
                                    color: PColors.color000000,
                                  ),
                                ),
                                const SizedBox(width: 8), // Add spacing
                                textWidget(
                                  text: _formatTimeAgo(
                                      note.createdAt), // ✅ This should work
                                  fontsize: 11,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  _noNotesWidget(),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                _buildAddNoteField(context, provider),
              ],
            )
        ],
      ),
    );
  }

  Widget _noNotesWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.note_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            textWidget(
              text: "No notes yet",
              color: Colors.grey,
              fontsize: 13,
            ),
          ],
        ),
      ),
    );
  }

// ✅ Add this helper function
  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A';
    }

    // ✅ FIX: Convert to local time FIRST, then get current time in local
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now(); // This is already in local time
    final difference = now.difference(localDateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${localDateTime.day}/${localDateTime.month}/${localDateTime.year}';
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';

    // Convert UTC to local time
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDateTime);

    // Format based on how long ago
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Format as date for older entries
      return '${localDateTime.day}/${localDateTime.month}/${localDateTime.year}';
    }
  }

  // Separate widget for the add note field to manage its own state
  Widget _buildAddNoteField(
      BuildContext context, UserDetailsViewModel provider) {
    final TextEditingController noteController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: noteController,
              enabled: !provider.addNoteLoading,
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: PColors.color042F40),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: PColors.primaryColor, width: 2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: provider.addNoteLoading
                ? null
                : () async {
                    final noteText = noteController.text.trim();

                    if (noteText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a note'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    if (provider.userId != null) {
                      await provider.addUserNoteFn(
                        context,
                        userId: provider.userId!,
                        note: noteText,
                      );

                      // ✅ Only clear text field if successful
                      // getUserNotesFn is already called inside addUserNoteFn
                      if (provider.addNoteError == null) {
                        noteController.clear();
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor:
                  PColors.primaryColor.withValues(alpha: 0.6),
            ),
            child: provider.addNoteLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightSide(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _tabButton("Profile", 0),
            _tabButton("Photos", 1),
            _tabButton("Matched Profiles", 2),
            _tabButton("Chat Logs", 3),
            _tabButton("Transactions", 4),
            _tabButton("Support", 5),
          ],
        ),
        // const SizedBox(height: 16),
        if (_selectedTab == 0) const UserProfileTab(),
        if (_selectedTab == 2) const MatchedProfilesCard(),
        if (_selectedTab == 3) ChatLogsCard(),
        if (_selectedTab == 1) PhotosSection(),
        if (_selectedTab == 4) TransactionsCard(),
        if (_selectedTab == 5) SupportTicketsCard(),
      ],
    );
  }

  Widget _tabButton(String title, int index) {
    final bool selected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: selected ? PColors.colorFFFFFF : const Color(0xFFF7F9FB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(index == 0 ? 8 : 0),
                topRight: Radius.circular(index == 2 ? 8 : 0),
              ),
              border: Border.all(
                color: selected ? Color(0xffE5E8EC) : Colors.transparent,
              )),
          child: Text(
            title,
            style: TextStyle(
              color: selected ? PColors.primaryColor : PColors.color042F40,
            ),
          ),
        ),
      ),
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
}
