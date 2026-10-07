import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';

class NotificationTabBar extends StatefulWidget {
  final Function(String) onTabChanged;
  final String? initialTab;

  const NotificationTabBar({
    super.key,
    required this.onTabChanged,
    this.initialTab,
  });

  @override
  State<NotificationTabBar> createState() => _NotificationTabBarState();
}

class _NotificationTabBarState extends State<NotificationTabBar> {
  String _selectedTab = 'All Notifications';

  final Map<String, String> _tabs = {
    'All Notifications': '',
    'Promotional': 'Promotional',
    'Offer': 'Offer',
    'Other': 'Other',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialTab != null && _tabs.containsKey(widget.initialTab)) {
      _selectedTab = widget.initialTab!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _tabs.keys.map((tab) => _buildTab(tab)).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(String tabName) {
    final isSelected = _selectedTab == tabName;
    final isFirst = _tabs.keys.first == tabName;

    return Padding(
      padding: EdgeInsets.only(right: isFirst ? 12 : 0, left: isFirst ? 0 : 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = tabName;
          });
          // Pass the type value to the callback
          widget.onTabChanged(_tabs[tabName]!);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                tabName,
                style: TextStyle(
                  color: isSelected
                      ? PColors.primaryColor
                      : const Color(0xFF67728D),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            // Green underline for selected tab
            Container(
              height: 2,
              width: 60,
              decoration: BoxDecoration(
                color: isSelected ? PColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
