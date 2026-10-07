import 'package:everqpidadmin/Features/notification_management/notification/view/widgets/notification_filter.dart';
import 'package:everqpidadmin/Features/notification_management/notification/view/widgets/notification_header.dart';
import 'package:everqpidadmin/Features/notification_management/notification/view/widgets/notification_table.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/notification_provider.dart';
import 'widgets/notification_tabbar.dart';

class NotificationUi extends StatefulWidget {
  const NotificationUi({super.key});

  @override
  State<NotificationUi> createState() => _NotificationUiState();
}

class _NotificationUiState extends State<NotificationUi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NotificationProvider>();

    return Container(
      decoration: BoxDecoration(color: PColors.scaffoldColor2),
      padding: const EdgeInsets.only(left: 17, right: 20),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationHeader(
              onAddNotification: () {
                // Handle add notification
              },
            ),
            NotificationFilterWidget(
              onSearchChanged: (search) {
                provider.searchTag = search;
              },
              onFromDateChanged: (from) {
                provider.fromDate = from != null
                    ? "${from.year.toString().padLeft(4, '0')}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}"
                    : "";
              },
              onToDateChanged: (to) {
                provider.toDate = to != null
                    ? "${to.year.toString().padLeft(4, '0')}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}"
                    : "";
              },
              onFilterPressed: () {
                provider.fetchEvents(
                  search: provider.searchTag,
                  startDate: provider.fromDate,
                  endDate: provider.toDate,
                  type: provider.type,
                );
              },
            ),
            const SizedBox(height: 20),
            NotificationTabBar(
              onTabChanged: (type) {
                // Update the type in provider and fetch notifications
                provider.type = type;
                provider.fetchEvents(
                  search: provider.searchTag,
                  startDate: provider.fromDate,
                  endDate: provider.toDate,
                  type: type,
                );
              },
            ),
            const SizedBox(height: 20),
            const NotificationBody(),
          ],
        ),
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
