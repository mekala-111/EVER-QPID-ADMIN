import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';
import '../../utils/p_colors.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? heigth;
  final double? borderRaduis;
  final Color? bordercolor;
  final Color? forgcolor;
  final double? padverticle;
  final double? padhorizondal;
  final Function() onPressed;

  const CustomOutlineButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.heigth,
    this.bordercolor,
    this.forgcolor,
    this.borderRaduis,
    this.padverticle,
    this.padhorizondal,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: PColors.colorFFFFFF,
        foregroundColor: forgcolor ?? PColors.primaryColor,
        // padding: EdgeInsets.symmetric(
        //     vertical: padverticle ?? 8, horizontal: padhorizondal ?? 16),
        fixedSize: Size(width ?? size.width - 32, heigth ?? 45),
        minimumSize: Size(width ?? size.width - 32, heigth ?? 45),
        maximumSize: Size(width ?? size.width - 32, heigth ?? 45),
        side: BorderSide(
          width: 1,
          color: bordercolor ?? PColors.primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRaduis ?? 24),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: getTextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
