import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';

class CustomExpandableTile extends StatefulWidget {
  final String title;
  final String keyValue; // Parent key for navigation
  final Widget icon;
  final List<Map<String, String>>
      children; // [{'title': 'All Users', 'key': 'all_users'}]
  final bool initiallyExpanded;
  final int badgeCount;
  final bool isSelected; // Is parent selected
  final String? selectedChildKey; // Currently selected child key
  final Function(String key)? onChildTap;
  final VoidCallback? onTap;

  const CustomExpandableTile({
    super.key,
    required this.title,
    required this.keyValue,
    required this.icon,
    required this.children,
    this.initiallyExpanded = false,
    this.badgeCount = 0,
    this.isSelected = false,
    this.selectedChildKey,
    this.onChildTap,
    this.onTap,
  });

  @override
  State<CustomExpandableTile> createState() => _CustomExpandableTileState();
}

class _CustomExpandableTileState extends State<CustomExpandableTile>
    with SingleTickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void toggleExpand() {
    setState(() => _expanded = !_expanded);
    widget.onTap?.call();
  }

  /// Checks if parent should be highlighted
  bool get isParentSelected {
    if (widget.isSelected) return true;
    if (widget.selectedChildKey != null &&
        widget.children.any((c) => c['key'] == widget.selectedChildKey)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isParentSelected ? PColors.primaryColor : Colors.transparent;
    final Color textColor =
        isParentSelected ? Colors.white : const Color(0xFF3A414D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent Tile
        GestureDetector(
          onTap: toggleExpand,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              children: [
                widget.icon,
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                if (widget.badgeCount > 0)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: ShapeDecoration(
                      color: PColors.primaryColor,
                      shape: OvalBorder(),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                if (widget.children.isNotEmpty)
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: textColor,
                  ),
              ],
            ),
          ),
        ),

        // Child Tiles with connected lines and dots
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 6, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children.asMap().entries.map((entry) {
                final index = entry.key;
                final childMap = entry.value;
                final String childTitle = childMap['title']!;
                final String childKey = childMap['key']!;
                final bool isChildSelected =
                    widget.selectedChildKey == childKey;

                final bool isFirst = index == 0;
                final bool isLast = index == widget.children.length - 1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Vertical connecting line
                      Positioned(
                        left: -7,
                        top: isFirst ? 21 : 0,
                        bottom: isLast ? 21 : 0,
                        child: Container(width: 2, color: Colors.grey.shade300),
                      ),

                      // Dot
                      Positioned(
                        left: -9,
                        top: 18,
                        child: Container(
                          width: isChildSelected ? 8 : 6,
                          height: isChildSelected ? 8 : 6,
                          decoration: ShapeDecoration(
                            color: isChildSelected
                                ? PColors.primaryColor
                                : const Color(0xFF3A414D),
                            shape: const OvalBorder(),
                          ),
                        ),
                      ),

                      // Child Label
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => widget.onChildTap?.call(childKey),
                            child: Container(
                              width: 210,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: ShapeDecoration(
                                color: isChildSelected
                                    ? PColors.primaryColor
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                childTitle,
                                style: TextStyle(
                                  color: isChildSelected
                                      ? Colors.white
                                      : const Color(0xFF3A414D),
                                  fontSize: 17,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ],
    );
  }
}
