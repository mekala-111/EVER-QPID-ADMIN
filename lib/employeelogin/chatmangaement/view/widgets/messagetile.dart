import 'package:flutter/material.dart';

class EmployeeMessagetile extends StatelessWidget {
  final String name;
  final String? lastMessage;
  final bool isSelected;
  final int unreadCount;
  final String? profileImageUrl;
  final VoidCallback? onTap;

  const EmployeeMessagetile({
    super.key,
    required this.name,
    this.lastMessage,
    this.isSelected = false,
    this.unreadCount = 0,
    this.profileImageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff9B6AF3) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            /// 👤 Profile (icon instead of image if empty)
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              backgroundImage:
                  profileImageUrl != null && profileImageUrl!.isNotEmpty
                      ? NetworkImage(profileImageUrl!)
                      : null,
              child: profileImageUrl == null || profileImageUrl!.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),

            const SizedBox(width: 10),

            /// 📝 Name + Last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastMessage ?? "No messages yet",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔔 Unread badge
            // if (unreadCount > 0)
            //   CircleAvatar(
            //     radius: 10,
            //     backgroundColor: Colors.purple,
            //     child: Text(
            //       unreadCount.toString(),
            //       style:
            //           const TextStyle(fontSize: 11, color: Colors.white),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
