import 'package:everqpidadmin/Features/wrapper/wrapper/view_model/viewmodelnew.dart';
import 'package:everqpidadmin/Settings/common/widgets/textwidget.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Employeewrappermenu extends StatelessWidget {
  const Employeewrappermenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WrapperViewModelNew, String>(
      selector: (p0, p1) => p1.viewStatus,
      builder: (BuildContext context, String value, Widget? child) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: menuTileWidget(
              title: "Chat Management",
              icon: 'assets/images/chat.png',
              isSelected: value == GetWrapperPageViewStatus.employeechat,
              onTap: () {
                context
                    .read<WrapperViewModelNew>()
                    .updatePageIndex(GetWrapperPageViewStatus.employeechat);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: menuTileWidget(
              title: "Recieved Likes",
              icon: 'assets/images/chat.png',
              isSelected: value == GetWrapperPageViewStatus.recievedLikes,
              onTap: () {
                context
                    .read<WrapperViewModelNew>()
                    .updatePageIndex(GetWrapperPageViewStatus.recievedLikes);
              },
            ),
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
        child: Selector<WrapperViewModelNew, String>(
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
    final model = context.read<WrapperViewModelNew>();

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
