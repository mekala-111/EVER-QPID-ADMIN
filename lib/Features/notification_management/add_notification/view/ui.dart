import 'package:everqpidadmin/Features/notification_management/add_notification/model/notification_list_model.dart';
import 'package:everqpidadmin/Features/notification_management/add_notification/view/widgets/notification_form.dart';
import 'package:everqpidadmin/Features/notification_management/notification/view/widgets/notification_table.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart' hide Notification; // Add hide here too
import 'package:provider/provider.dart';

import '../view_model/notification_provider.dart';

class AddNotificationUi extends StatelessWidget {
  final NotificationModel? notificationToEdit;
  final bool isEditMode;

  const AddNotificationUi({
    super.key,
    this.notificationToEdit,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get notification from existing provider if not passed
    final provider = context.watch<AddNotificationProvider>();
    final notification = notificationToEdit ?? provider.selectedNotification;
    final editMode = isEditMode || (notification != null);

    return Container(
      decoration: BoxDecoration(color: PColors.scaffoldColor2),
      padding: const EdgeInsets.only(left: 17, right: 20),
      height: MediaQuery.of(context).size.height,
      child: AddNotificationForm(
        notificationToEdit: notification,
        isEditMode: editMode,
      ),
    );
  }
}

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationTable();
  }
}
