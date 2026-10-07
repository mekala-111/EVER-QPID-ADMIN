import 'package:everqpidadmin/Features/hostmanagement/view/hostdetails/view/widgets/chatlogswidget.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/hostdetails/view/widgets/matcheprofilewidget.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/hostdetails/view/widgets/photosection.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/hostdetails/view/widgets/profilewidget.dart';
import 'package:everqpidadmin/Features/hostmanagement/view/hostdetails/view/widgets/sendlikewidget.dart';
import 'package:everqpidadmin/Features/hostmanagement/viewmodel/hostdetailsviewmodel.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';

import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../Settings/utils/p_colors.dart';

class HostDetailsScreen extends StatefulWidget {
  const HostDetailsScreen({super.key});

  @override
  State<HostDetailsScreen> createState() => _HostDetailsScreenState();
}

class _HostDetailsScreenState extends State<HostDetailsScreen> {
  int _selectedTab = 0;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotes();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadNotes() {
    final provider = context.read<Hostdetailsviewmodel>();
    final userId = context
        .read<Hostdetailsviewmodel>()
        .userId; // Adjust based on your model

    if (userId != null) {
      provider.getUserNotesFn(context, userId: userId);
    }
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
                    text: "Host Details",
                    fontweight: FontWeight.w700,
                    fontsize: 20),
                GestureDetector(
                    onTap: () {
                      context
                          .read<WrapperViewModel>()
                          .updatePageIndex(GetWrapperPageViewStatus.allhost);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.blueGrey,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            textWidget(
                text: "Admin / Host Management / John Doe",
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
    final provider = context.watch<Hostdetailsviewmodel>();
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
                        text: "Joined ${formatJoinedDate(
                          sideProfile?.joinedDate != null
                              ? DateTime.tryParse(
                                  sideProfile!.joinedDate.toString())
                              : null,
                        )}",
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
                  const SizedBox(width: 15),
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
                  const SizedBox(width: 20),
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
                        context
                            .read<WrapperViewModel>()
                            .updatePageIndex(GetWrapperPageViewStatus.addHost);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm Delete"),
                            content: const Text(
                                "Are you sure you want to delete this host?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          context.read<Hostdetailsviewmodel>().deleteHost(
                                context,
                                userId: context
                                    .read<Hostdetailsviewmodel>()
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
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: PColors.color042F40),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// Internal Notes - Integrated with API
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
                          "Admin", // or map from note.addedBy if needed
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
                                  context.read<Hostdetailsviewmodel>().userId;
                              if (userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('User ID not found'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

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
      children: [
        Row(
          children: [
            _tabButton("Profile", 0),
            _tabButton("Photos", 1),
            _tabButton("Matched Profiles", 2),
            _tabButton("Chat Logs", 3),
            _tabButton("Send Likes", 4),
          ],
        ),
        if (_selectedTab == 0) const HostProfileTab(),
        if (_selectedTab == 2) const HostMatchedProfilesCard(),
        if (_selectedTab == 3) HostChatLogsCard(),
        if (_selectedTab == 1) HostPhotosSection(),
        if (_selectedTab == 4) Sendlikewidget(),
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
                color: selected ? const Color(0xffE5E8EC) : Colors.transparent,
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

  Widget _noteItem(String by, String title, String date, String? subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: by, fontweight: FontWeight.w600, fontsize: 13),
        const SizedBox(height: 4),
        textWidget(text: title, fontsize: 13),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          textWidget(text: subtitle, fontsize: 11, color: Colors.grey),
        ],
        if (date.isNotEmpty) ...[
          const SizedBox(height: 2),
          textWidget(text: date, fontsize: 11, color: Colors.grey),
        ],
      ],
    );
  }
}
