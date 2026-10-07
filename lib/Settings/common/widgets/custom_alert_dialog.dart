import 'package:everqpidadmin/Settings/common/widgets/custom_elevated_button.dart';
import 'package:everqpidadmin/Settings/common/widgets/custom_outline_button.dart';
import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';
import '../../utils/p_colors.dart';

class CustomAlertDailog extends StatelessWidget {
  const CustomAlertDailog({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
    this.titleColor,
  });
  final String title;
  final String content;
  final void Function()? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //  insetPadding: EdgeInsets.zero,
      //   contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        title,
        style: getTextStyle(
          color: titleColor ?? PColors.color000000,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.40,
        ),
      ),
      content: Builder(
        builder: (context) {
          return Text(
            content,
            style: getTextStyle(
              color: PColors.color000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 152 / MediaQuery.of(context).devicePixelRatio,
          height: 41 / MediaQuery.of(context).devicePixelRatio,
          child: CustomOutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Cancel',
          ),
        ),
        SizedBox(
          width: 152 / MediaQuery.of(context).devicePixelRatio,
          height: 41 / MediaQuery.of(context).devicePixelRatio,
          child: CustomElavatedTextButton(text: 'Confirm', onPressed: onTap),
        ),
      ],
    );
  }
}
