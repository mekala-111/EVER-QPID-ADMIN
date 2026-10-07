import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/view_model.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:everqpidadmin/Settings/utils/p_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class WrapperMenuSectionUi extends StatelessWidget {
  const WrapperMenuSectionUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WrapperViewModel, String>(
      selector: (p0, p1) => p1.viewStatus,
      builder: (BuildContext context, String value, Widget? child) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: menuTileWidget(
              title: "Dashboard",
              icon: 'assets/images/dashboard.png',
              isSelected: value == GetWrapperPageViewStatus.dashboard,
              onTap: () {
                Navigator.pushReplacementNamed(context, PPages.dashboard);
              },
            ),
          ),
          expansionTileWidget(
            title: "User Management",
            icon: 'assets/images/users.png',
            children: [
              GetWrapperPageViewStatus.users,
              GetWrapperPageViewStatus.maleusers,
              GetWrapperPageViewStatus.femaleusers,
              GetWrapperPageViewStatus.reported,
            ],
            selectedStatus: value,
            // count: "5",
            context: context,
          ),
          expansionTileWidget(
            title: "Host Management",
            icon: 'assets/images/host.png',
            children: [
              GetWrapperPageViewStatus.allhost,
              GetWrapperPageViewStatus.activehost,
              GetWrapperPageViewStatus.inactivehost,
            ],
            selectedStatus: value,
            // count: "5",
            context: context,
          ),
          expansionTileWidget(
            title: "Revenue Management",
            icon: 'assets/images/revenue_management.png',
            children: [
              GetWrapperPageViewStatus.revenue,
              GetWrapperPageViewStatus.transaction,
            ],
            selectedStatus: value,
            // count: "5",
            context: context,
          ),
          menuTileWidget(
            title: "Plan Management",
            icon: 'assets/images/plan.png',
            isSelected: value == GetWrapperPageViewStatus.plans,
            onTap: () {
              context
                  .read<WrapperViewModel>()
                  .updatePageIndex(GetWrapperPageViewStatus.plans);
            },
          ),
          expansionTileWidget(
            title: "Help & Support",
            icon: 'assets/images/help.png',
            children: [
              GetWrapperPageViewStatus.tickets,
              GetWrapperPageViewStatus.email,
            ],
            selectedStatus: value,
            // count: "5",
            context: context,
          ),
          menuTileWidget(
            title: "Notifications",
            icon: 'assets/images/notification.png',
            isSelected: value == GetWrapperPageViewStatus.notification,
            onTap: () {
              context
                  .read<WrapperViewModel>()
                  .updatePageIndex(GetWrapperPageViewStatus.notification);
            },
          ),
          menuTileWidget(
            title: "Chat Management",
            icon: 'assets/images/chat.png',
            isSelected: value == GetWrapperPageViewStatus.chat,
            onTap: () {
              Navigator.pushReplacementNamed(context, PPages.chat);
            },
          ),
          menuTileWidget(
            title: "Clan Management",
            icon: 'assets/images/clan.png',
            isSelected: value == GetWrapperPageViewStatus.clan,
            onTap: () {
              context
                  .read<WrapperViewModel>()
                  .updatePageIndex(GetWrapperPageViewStatus.clan);
            },
          ),
          expansionTileWidget(
            title: "Settings",
            icon: 'assets/images/settings.png',
            children: [
              GetWrapperPageViewStatus.employees,
            ],
            selectedStatus: value,
            // count: "5",
            context: context,
          ),
        ],
      ),
    );
  }

  Widget menuTileWidget({
    required String title,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? PColors.primaryColor : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 20,
              width: 20,
              color: isSelected ? Colors.white : PColors.color000000,
            ),
            const SizedBox(width: 12),
            textWidget(
              text: title,
              fontsize: 15,
              fontweight: FontWeight.w400,
              color: isSelected ? Colors.white : PColors.color000000,
            ),
          ],
        ),
      ),
    );
  }

  Widget expansionTileWidget({
    required String title,
    required String icon,
    required List<String> children,
    Map<String, List<String>>? childDetailPages,
    required String selectedStatus,
    String? count,
    required BuildContext context,
  }) {
    bool isSelected = children.contains(selectedStatus);
    if (!isSelected && childDetailPages != null) {
      for (var detailPages in childDetailPages.values) {
        if (detailPages.contains(selectedStatus)) {
          isSelected = true;
          break;
        }
      }
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Selector<WrapperViewModel, String>(
          selector: (p0, p1) => p1.viewStatus,
          builder: (context, value, child) => ExpansionTile(
            initiallyExpanded: isSelected,
            leading: Image.asset(
              icon,
              fit: BoxFit.contain,
              height: 20,
              color: Colors.black,
              width: 20,
            ),
            title: Row(
              children: [
                Expanded(
                  child: textWidget(
                    text: title,
                    fontsize: 15,
                    fontweight: FontWeight.w400,
                    color: PColors.color000000,
                  ),
                ),
                if (count != null && count.isNotEmpty && count != "0") ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(minWidth: 24),
                    child: Text(
                      count,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  children: children.asMap().entries.map((entry) {
                    int index = entry.key;
                    String child = entry.value;
                    bool selected = child == selectedStatus;

                    if (!selected &&
                        childDetailPages != null &&
                        childDetailPages.containsKey(child)) {
                      selected =
                          childDetailPages[child]!.contains(selectedStatus);
                    }

                    bool isLast = index == children.length - 1;
                    bool isFirst = index == 0;

                    return childListtileWithTimeline(
                      child,
                      context,
                      selected,
                      isLast,
                      isFirst,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget childListtileWithTimeline(
    String title,
    BuildContext context,
    bool selected,
    bool isLast,
    bool isFirst,
  ) {
    final model = context.read<WrapperViewModel>();

    return SizedBox(
      height: 60,
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.05,
        isFirst: isFirst,
        isLast: isLast,
        indicatorStyle: IndicatorStyle(
          width: 8,
          color: selected ? PColors.primaryColor : Colors.grey.shade400,
          padding: EdgeInsets.zero,
        ),
        beforeLineStyle: LineStyle(
          color: Colors.black12,
          thickness: 1,
        ),
        afterLineStyle: LineStyle(
          color: Colors.black12,
          thickness: 1,
        ),
        endChild: GestureDetector(
          onTap: () => model.updatePageIndex(title),
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: selected ? PColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: textWidget(
              text: title,
              fontsize: 14,
              color: selected ? Colors.white : PColors.color000000,
              fontweight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
