import 'package:everqpidadmin/Features/notification_management/add_notification/view_model/notification_provider.dart';
import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationHeader extends StatelessWidget {
  final VoidCallback onAddNotification;
  final VoidCallback? onFilterPressed;

  const NotificationHeader({
    super.key,
    required this.onAddNotification,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          const Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFF091128),
              fontSize: 28,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),

          // Right side actions
          SizedBox(
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                context
                    .read<AddNotificationProvider>()
                    .setSelectedNotification(null);
                context.read<WrapperViewModel>().updatePageIndex(
                      GetWrapperPageViewStatus.addnotification,
                    );
              },
              label: const Text(
                'ADD NOTIFICATION +',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: PColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),

                  // side: const BorderSide(
                  //   // color: Colors.green, // ✅ Green border
                  //   width: 1.5,
                  // ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
