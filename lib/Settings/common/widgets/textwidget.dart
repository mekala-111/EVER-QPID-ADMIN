import 'package:flutter/material.dart';
import '../../constants/text_styles.dart';

Widget textWidget({
  String? text,
  double? fontsize,
  FontWeight? fontweight,
  Color? color,
  TextOverflow? overflow,
  TextAlign? textAlign,
  int? maxLines,
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  return Text(
    text ?? '',
    overflow: overflow,
    textAlign: textAlign,
    maxLines: maxLines,
    style: getTextStyle(
      fontSize: fontsize,
      fontWeight: fontweight,
      color: color,
      decoration: decoration,
      // d: decorationColor,
    ),
  );
}

Widget selectableTextWidget({
  String? text,
  double? fontsize,
  FontWeight? fontweight,
  Color? color,
  TextAlign? textAlign,
  TextDecoration? decoration,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return SelectableText(
    text ?? '',
    textAlign: textAlign,
    maxLines: maxLines,
    style: getTextStyle(
      fontSize: fontsize,
      fontWeight: fontweight,
      color: color,
      decoration: decoration,
    ),
  );
}
