import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';

class SubHeader extends StatelessWidget {
  final String title;
  const SubHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: PColors.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
