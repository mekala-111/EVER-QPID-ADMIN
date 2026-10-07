import 'package:everqpidadmin/Features/notification_management/add_notification/model/notification_list_model.dart';
import 'package:everqpidadmin/Features/notification_management/add_notification/view_model/notification_provider.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../view_model/notification_provider.dart';

class NotificationTable extends StatefulWidget {
  const NotificationTable({super.key});

  @override
  State<NotificationTable> createState() => _NotificationTableState();
}

class _NotificationTableState extends State<NotificationTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final notifications = provider.notifications;

        if (notifications.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.notifications_none,
                    size: 60,
                    color: Color(0xFF67728D),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "No Notifications Found",
                    style: TextStyle(
                      color: Color(0xFF191C1F),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "You don't have any notifications yet",
                    style: TextStyle(
                      color: Color(0xFF67728D),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE5E8EC)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // Title
              //       const Text(
              //         'All Notifications',
              //         style: TextStyle(
              //           color: Color(0xFF091128),
              //           fontSize: 17,
              //           fontFamily: 'Roboto',
              //           fontWeight: FontWeight.w500,
              //           height: 1.30,
              //         ),
              //       ),
              //       const SizedBox(height: 16),

              //       // Search, Date, and Filter Row
              //       Row(
              //         children: [
              //           // Search Field
              //           Expanded(
              //             flex: 3,
              //             child: Container(
              //               height: 41,
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 16,
              //                 vertical: 8,
              //               ),
              //               decoration: ShapeDecoration(
              //                 color: Colors.white,
              //                 shape: RoundedRectangleBorder(
              //                   side: const BorderSide(
              //                     width: 1,
              //                     color: Color(0xFFE4E7EB),
              //                   ),
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //               child: Row(
              //                 children: [
              //                   const Icon(
              //                     Icons.search,
              //                     size: 20,
              //                     color: Color(0xFF67728D),
              //                   ),
              //                   const SizedBox(width: 8),
              //                   Expanded(
              //                     child: TextField(
              //                       decoration: const InputDecoration(
              //                         hintText: 'Search',
              //                         hintStyle: TextStyle(
              //                           color: Color(0xFF67728D),
              //                           fontSize: 14,
              //                           fontFamily: 'Roboto',
              //                           fontWeight: FontWeight.w400,
              //                           height: 1.50,
              //                         ),
              //                         border: InputBorder.none,
              //                         isDense: true,
              //                         contentPadding: EdgeInsets.zero,
              //                       ),
              //                       style: const TextStyle(
              //                         fontSize: 14,
              //                         fontFamily: 'Roboto',
              //                       ),
              //                       onChanged: (value) {
              //                         // Add search functionality
              //                       },
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 12),

              //           // Date Picker
              //           GestureDetector(
              //             onTap: () async {
              //               // Add date picker functionality
              //             },
              //             child: Container(
              //               width: 150,
              //               height: 41,
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 16,
              //                 vertical: 8,
              //               ),
              //               decoration: ShapeDecoration(
              //                 color: Colors.white,
              //                 shape: RoundedRectangleBorder(
              //                   side: const BorderSide(
              //                     width: 1,
              //                     color: Color(0xFFE4E7EB),
              //                   ),
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //               child: const Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Icon(
              //                     Icons.calendar_today,
              //                     size: 18,
              //                     color: Color(0xFF67728D),
              //                   ),
              //                   SizedBox(width: 8),
              //                   Expanded(
              //                     child: Text(
              //                       'MM/DD/YYYY',
              //                       style: TextStyle(
              //                         color: Color(0xFF67728D),
              //                         fontSize: 14,
              //                         fontFamily: 'Roboto',
              //                         fontWeight: FontWeight.w400,
              //                         height: 1.50,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 12),

              //           // Filter Button
              //           GestureDetector(
              //             onTap: () {
              //               // Add filter functionality
              //             },
              //             child: Container(
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 20,
              //                 vertical: 10,
              //               ),
              //               decoration: ShapeDecoration(
              //                 color: const Color(0xFF5B5126),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //               child: const Text(
              //                 'Filter',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 14,
              //                   fontFamily: 'Roboto',
              //                   fontWeight: FontWeight.w400,
              //                   height: 1.50,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 20),
              //     ],
              //   ),
              // ),

              // Column Headers
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xFFE4E7EB)),
                  ),
                ),
                child: Row(
                  children: [
                    _buildHeaderCell('Title', flex: 3),
                    _buildHeaderCell('Type', flex: 2),
                    _buildHeaderCell('Target Users', flex: 3),
                    _buildHeaderCell('Interval', flex: 3),
                    _buildHeaderCell('Pause', flex: 2),
                    _buildHeaderCell(
                      'Action',
                      flex: 1,
                      alignment: Alignment.centerRight,
                    ),
                  ],
                ),
              ),

              // Data Rows
              ...notifications.map(
                (notification) => _buildDataRow(notification, context),
              ),

              // Pagination Footer
              // _buildPaginationFooter(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(
    String text, {
    int flex = 1,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF67728D),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(NotificationModel notification, BuildContext context) {
    final title = notification.title;
    final type = notification.type;

    final targetUsers = _formatTargetUsersFromList(notification.recipients);

    final interval = _formatInterval(notification.schedule);
    final isPaused = notification.isPaused; // ✅ non-nullable
    final notificationId = notification.id;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE4E7EB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF091128),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),

          // Type
          Expanded(
            flex: 2,
            child: Text(
              type.isNotEmpty ? type[0].toUpperCase() + type.substring(1) : '—',
              style: const TextStyle(
                color: Color(0xFF091128),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),

          // Target Users
          Expanded(
            flex: 3,
            child: Text(
              targetUsers,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF091128),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),

          // Interval
          Expanded(
            flex: 3,
            child: Text(
              interval,
              style: const TextStyle(
                color: Color(0xFF091128),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),

          // Pause Toggle
          Expanded(
            flex: 2,
            child: AbsorbPointer(
              absorbing: context
                  .read<NotificationProvider>()
                  .isLoading, // prevent double taps
              child: GestureDetector(
                onTap: () async {
                  await context.read<NotificationProvider>().toggleNotification(
                        notificationId: notificationId,
                        isPaused: '$isPaused' == 'true' ? false : true,
                      );
                },
                child: _buildToggleSwitch(isPaused),
              ),
            ),
          ),

          // Edit Button
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  context
                      .read<AddNotificationProvider>()
                      .setSelectedNotification(notification);

                  context.read<WrapperViewModel>().updatePageIndex(
                        GetWrapperPageViewStatus.addnotification,
                      );
                },
                child: Container(
                  width: 56,
                  height: 32,
                  decoration: ShapeDecoration(
                    color: PColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTargetUsersFromList(List<String> recipients) {
    if (recipients.isEmpty) return 'All Users';

    if (recipients.contains('all')) return 'All Users';

    return recipients
        .map((e) => e.replaceAll('_', ' '))
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : e)
        .join(', ');
  }

  String _formatInterval(Schedule schedule) {
    try {
      final formatter = DateFormat('dd MMM yyyy');
      return '${formatter.format(schedule.startDate)} - ${formatter.format(schedule.endDate)}';
    } catch (e) {
      return '—';
    }
  }

  Widget _buildToggleSwitch(bool isActive) {
    return SizedBox(
      width: 58,
      height: 38,
      child: Stack(
        children: [
          // Background Track
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 34,
              height: 14,
              decoration: ShapeDecoration(
                color: isActive
                    ? PColors.primaryColor
                    : Colors.black.withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          // Thumb
          Positioned(
            left: isActive ? 30 : 9,
            top: 9,
            child: Container(
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                color: const Color(0xFFF5F5F5),
                shape: const OvalBorder(),
                shadows: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 1,
                    offset: Offset(0, 2),
                    spreadRadius: -1,
                  ),
                  BoxShadow(
                    color: Color(0x23000000),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPaginationFooter(NotificationProvider provider) {
  //   final notifications = provider.Notifications;
  //   final total = notifications.length;

  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         // Rows per page
  //         Row(
  //           children: [
  //             Text(
  //               'Rows per page:',
  //               style: TextStyle(
  //                 color: Colors.black.withValues(alpha: 0.60),
  //                 fontSize: 12,
  //                 fontFamily: 'Roboto',
  //                 fontWeight: FontWeight.w400,
  //                 height: 1.66,
  //                 letterSpacing: 0.40,
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               '10',
  //               style: TextStyle(
  //                 color: Colors.black.withValues(alpha: 0.87),
  //                 fontSize: 12,
  //                 fontFamily: 'Roboto',
  //                 fontWeight: FontWeight.w400,
  //                 height: 1.66,
  //                 letterSpacing: 0.40,
  //               ),
  //             ),
  //             const Icon(
  //               Icons.arrow_drop_down,
  //               size: 18,
  //               color: Color(0xFF67728D),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(width: 26),

  //         // Page info
  //         Text(
  //           '1-$total of $total',
  //           style: TextStyle(
  //             color: Colors.black.withValues(alpha: 0.87),
  //             fontSize: 12,
  //             fontFamily: 'Roboto',
  //             fontWeight: FontWeight.w400,
  //             height: 1.66,
  //             letterSpacing: 0.40,
  //           ),
  //         ),
  //         const SizedBox(width: 16),

  //         // Navigation buttons
  //         Row(
  //           children: [
  //             IconButton(
  //               padding: const EdgeInsets.all(8),
  //               constraints: const BoxConstraints(),
  //               icon: const Icon(
  //                 Icons.chevron_left,
  //                 size: 24,
  //                 color: Color(0xFF67728D),
  //               ),
  //               onPressed: () {
  //                 // Add previous page functionality
  //               },
  //             ),
  //             const SizedBox(width: 8),
  //             IconButton(
  //               padding: const EdgeInsets.all(8),
  //               constraints: const BoxConstraints(),
  //               icon: const Icon(
  //                 Icons.chevron_right,
  //                 size: 24,
  //                 color: Color(0xFF67728D),
  //               ),
  //               onPressed: () {
  //                 // Add next page functionality
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
