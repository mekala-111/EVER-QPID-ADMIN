import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? changeText;
  final bool isPositive;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.changeText,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color changeColor = isPositive ? const Color(0xFF59BE1C) : Colors.red;
    final IconData changeIcon =
        isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      height: 107,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF67728D),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),

          // Value + change
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF091128),
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (changeText != null) ...[
                const SizedBox(width: 8),
                Icon(changeIcon, size: 16, color: changeColor),
                const SizedBox(width: 2),
                Text(
                  changeText!,
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
