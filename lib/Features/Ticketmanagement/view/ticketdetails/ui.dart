import 'package:everqpidadmin/Features/Ticketmanagement/view/widgets/ticketdetailscard.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/ticketdetailsviewmodel.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../Settings/utils/p_colors.dart';

class Ticketdetails extends StatefulWidget {
  const Ticketdetails({super.key});

  @override
  State<Ticketdetails> createState() => _TicketdetailsState();
}

class _TicketdetailsState extends State<Ticketdetails> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ticketId = context.read<TicketDetailsViewModel>().tcketId;

      if (ticketId == null) {
        return;
      }

      context.read<TicketDetailsViewModel>().getTicketDetails(
            context,
            ticketId: ticketId,
          );
    });
  }

  final TextEditingController _noteController = TextEditingController();
  void _loadNotes() {
    final provider = context.read<TicketDetailsViewModel>();
    final userId =
        context.read<TicketsViewModel>().userId; // Adjust based on your model

    provider.getUserNotesFn(context, userId: userId);
  }

  String formatNoteDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return formatJoinedDate(date);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.scaffoldColor2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                  text: "Ticket Details",
                  fontweight: FontWeight.w700,
                  fontsize: 20,
                ),
                GestureDetector(
                    onTap: () {
                      context
                          .read<WrapperViewModel>()
                          .updatePageIndex(GetWrapperPageViewStatus.tickets);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.blueGrey,
                    ))
              ],
            ),
            const SizedBox(height: 8),
            textWidget(
              text: "Admin / Ticket Management / Details",
              fontsize: 12,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SIDE – USER CARD & NOTES
                Expanded(flex: 2, child: _buildLeftSide(context)),
                const SizedBox(width: 20),

                /// RIGHT SIDE – TICKET DETAILS
                Expanded(flex: 4, child: _buildRightSide(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSide(BuildContext context) {
    final provider = context.watch<TicketDetailsViewModel>();

    // Show loading only while fetching
    // if (provider.loading) {
    //   return Center(
    //     child: CircularProgressIndicator(color: PColors.primaryColor),
    //   );
    // }

    // Show error if present
    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Error: ${provider.error}',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final sideProfile = provider.sideProfileDetails;

    // ✅ Show placeholder when sideProfile is null (guest ticket)
    if (sideProfile == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PColors.color042F40),
        ),
        child: Column(
          children: [
            Icon(Icons.person_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Guest Ticket',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No user profile associated with this ticket',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Rest of your existing code for displaying sideProfile...

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
                    child: Text(
                      sideProfile.fullName.isNotEmpty == true
                          ? sideProfile.fullName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: textWidget(
                                text: sideProfile.fullName,
                                fontweight: FontWeight.w600,
                                fontsize: 16,
                              ),
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
                          text: sideProfile.joinedDate != null
                              ? "Joined ${formatJoinedDate(
                                  DateTime.tryParse(
                                      sideProfile.joinedDate.toString()),
                                )}"
                              : "Join date N/A",
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
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                          text: "Phone No.",
                          fontweight: FontWeight.w500,
                          fontsize: 12,
                          color: PColors.color000000,
                        ),
                        textWidget(
                          text: sideProfile.phoneNo.isNotEmpty == true
                              ? sideProfile.phoneNo
                              : "N/A",
                          fontsize: 13,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                          text: "Verification",
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
                              : Colors.orangeAccent,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
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
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                          text: "Subscription",
                          fontweight: FontWeight.w500,
                          fontsize: 12,
                          color: PColors.color000000,
                        ),
                        textWidget(
                          text: sideProfile.isSubscribed == true
                              ? 'Subscribed'
                              : 'Not Subscribed',
                          fontsize: 13,
                          color: sideProfile.isSubscribed == true
                              ? Colors.green
                              : Colors.orangeAccent,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
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
                    sideProfile.lastChatOn != null
                        ? formatDate(
                            sideProfile.lastChatOn is String
                                ? DateTime.tryParse(
                                    sideProfile.lastChatOn.toString())
                                : sideProfile.lastChatOn,
                          )
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

                  // Expanded(
                  //   child: OutlinedButton(
                  //     onPressed: () {
                  //       final isActive = provider.userProfile!.isActive;

                  //       if (isActive) {
                  //         // User is currently active, so deactivate
                  //         context.read<TicketsViewModel>().deActivateUserFn(
                  //               context,
                  //               userId: context
                  //                   .read<TicketsViewModel>()
                  //                   .userId
                  //                   .toString(),
                  //             );
                  //       } else {
                  //         // User is currently inactive, so activate
                  //         context.read<TicketsViewModel>().activateUserFn(
                  //               context,
                  //               userId: context
                  //                   .read<TicketsViewModel>()
                  //                   .userId
                  //                   .toString(),
                  //             );
                  //       }
                  //     },
                  //     style: OutlinedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       side: BorderSide(
                  //         color: provider.userProfile!.isActive
                  //             ? Colors.red
                  //             : Colors.green,
                  //       ),
                  //     ),
                  //     child: Text(
                  //       provider.userProfile!.isActive
                  //           ? "Deactivate"
                  //           : "Activate",
                  //       style: TextStyle(
                  //         color: provider.userProfile!.isActive
                  //             ? Colors.red
                  //             : Colors.green,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )
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

              // Loading state
              if (provider.notesLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )

              // Error state
              else if (provider.notesError != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Failed to load notes',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      TextButton(
                        onPressed: _loadNotes,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )

              // Display notes
              else if (provider.notesData != null &&
                  provider.notesData!.notes!.isNotEmpty)
                Column(
                  children: provider.notesData!.notes!.map((note) {
                    return Column(
                      children: [
                        _noteItem(
                          "Admin",
                          note.note ?? '',
                          formatNoteDate(note.createdAt),
                          null,
                        ),
                        const Divider(height: 24),
                      ],
                    );
                  }).toList(),
                )

              // Empty state
              else
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: textWidget(
                      text: "No notes yet",
                      fontsize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),

              // Add note input
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _noteController,
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
                      onPressed: provider.addNoteLoading
                          ? null
                          : () async {
                              final note = _noteController.text.trim();
                              if (note.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a note'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              final userId =
                                  context.read<TicketsViewModel>().userId;

                              await provider.addUserNoteFn(
                                context,
                                userId: userId,
                                note: note,
                              );

                              if (provider.addNoteError == null) {
                                _noteController.clear();
                                // Reload notes after adding
                                _loadNotes();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PColors.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: provider.addNoteLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
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
    return Column(
      children: [TicketDetailsCard()],
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
    final provider = context.read<TicketsViewModel>();

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
