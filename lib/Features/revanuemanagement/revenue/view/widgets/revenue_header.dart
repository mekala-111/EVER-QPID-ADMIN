import 'package:flutter/material.dart';

class RevenueHeaderWidget extends StatelessWidget {
  const RevenueHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 1060,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Revenue Management',
          style: TextStyle(
            color: Color(0xFF091128),
            fontSize: 29,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
