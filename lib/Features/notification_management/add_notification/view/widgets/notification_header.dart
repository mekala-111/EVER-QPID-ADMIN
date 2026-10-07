// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ruxsy_admin/Features/main_screen/view_model/side_bar_view_model.dart';

// class NotificationHeader extends StatelessWidget {
//   final VoidCallback onAddNotification;
//   final VoidCallback? onFilterPressed;

//   const NotificationHeader({
//     super.key,
//     required this.onAddNotification,
//     this.onFilterPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Title
//           const Text(
//             'Notifications',
//             style: TextStyle(
//               color: Color(0xFF091128),
//               fontSize: 28,
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w700,
//               height: 1.2,
//             ),
//           ),

//           // Right side actions
//           Row(
//             children: [
//               // Filter button
//               InkWell(
//                 onTap: onFilterPressed,
//                 borderRadius: BorderRadius.circular(8),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: const Color(0xFFE4E7EB),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     children: const [
//                       Text(
//                         'All',
//                         style: TextStyle(
//                           color: Color(0xFF67728D),
//                           fontSize: 14,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.w400,
//                           height: 1.5,
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Icon(
//                         Icons.keyboard_arrow_down_rounded,
//                         size: 18,
//                         color: Color(0xFF67728D),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),

//               // Add notification button
//               ElevatedButton.icon(
//                 onPressed: () {
//                   // Navigate using SidebarProvider
//                   Provider.of<SidebarProvider>(
//                     context,
//                     listen: false,
//                   ).selectItem('Add Notification');
//                 },
//                 icon: const Icon(Icons.add, color: Colors.white, size: 18),
//                 label: const Text(
//                   'Add Notification',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w400,
//                     height: 1.5,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF5B5126),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
