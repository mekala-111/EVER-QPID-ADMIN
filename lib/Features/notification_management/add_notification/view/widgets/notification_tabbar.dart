// import 'package:flutter/material.dart';

// class NotificationTabBar extends StatefulWidget {
//   final Function(String) onTabChanged;
//   final String? initialTab;

//   const NotificationTabBar({
//     super.key,
//     required this.onTabChanged,
//     this.initialTab,
//   });

//   @override
//   State<NotificationTabBar> createState() => _NotificationTabBarState();
// }

// class _NotificationTabBarState extends State<NotificationTabBar> {
//   String _selectedTab = 'All Notifications';

//   final List<String> _tabs = [
//     'All Notifications',
//     'Promotional',
//     'Offer',
//     'Other',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialTab != null && _tabs.contains(widget.initialTab)) {
//       _selectedTab = widget.initialTab!;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: _tabs.map((tab) => _buildTab(tab)).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildTab(String tabName) {
//     final isSelected = _selectedTab == tabName;
//     final isFirst = _tabs.indexOf(tabName) == 0;

//     return Padding(
//       padding: EdgeInsets.only(right: isFirst ? 12 : 0, left: isFirst ? 0 : 12),
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             _selectedTab = tabName;
//           });
//           widget.onTabChanged(tabName);
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           decoration: ShapeDecoration(
//             color: isSelected ? Colors.white : const Color(0xFFF6F6FA),
//             shape: RoundedRectangleBorder(
//               side: isSelected
//                   ? const BorderSide(width: 1, color: Color(0xFFE4E7EB))
//                   : BorderSide.none,
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             tabName,
//             style: TextStyle(
//               color: isSelected
//                   ? const Color(0xFF5B5126)
//                   : const Color(0xFF67728D),
//               fontSize: 14,
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w400,
//               height: 1.50,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
