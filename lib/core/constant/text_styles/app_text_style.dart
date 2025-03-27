import 'package:flutter/material.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/font_family.dart';

import 'app_font_weight.dart';

class AppTextStyle {
  static TextStyle getTextStyle(
      double fontSize, Color color, FontWeight fontWeight, String? fontFamily,
      {TextDecoration? textDecoration}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        decoration: textDecoration);
  }

  static TextStyle getRegularStyle(
      {double fontSize = AppFontSize.size_12,
      FontWeight? fontWeight,
      required Color color,
      String? fontFamily,
      TextDecoration? textDecoration}) {
    return getTextStyle(fontSize, color, fontWeight ?? AppFontWeight.regular,
        fontFamily ?? AppFontFamily.fontMontserrat,
        textDecoration: textDecoration);
  }

  static TextStyle getMediumStyle(
      {double fontSize = AppFontSize.size_12,
      required Color color,
      FontWeight? fontWeight,
      String? fontFamily}) {
    return getTextStyle(fontSize, color, fontWeight ?? AppFontWeight.medium,
        AppFontFamily.fontMontserrat);
  }

  static TextStyle getLightStyle(
      {double fontSize = AppFontSize.size_12,
      required Color color,
      FontWeight? fontWeight,
      String? fontFamily}) {
    return getTextStyle(fontSize, color, fontWeight ?? AppFontWeight.light,
        AppFontFamily.fontMontserrat);
  }

  static TextStyle getBoldStyle(
      {double fontSize = AppFontSize.size_12,
      required Color color,
      FontWeight? fontWeight,
      String? fontFamily,
      TextDecoration? textDecoration}) {
    return getTextStyle(fontSize, color, fontWeight ?? AppFontWeight.bold,
        AppFontFamily.fontMontserrat,
        textDecoration: textDecoration);
  }

  static TextStyle getSemiBoldStyle(
      {double fontSize = AppFontSize.size_12,
      required Color color,
      FontWeight? fontWeight,
      String? fontFamily,
      TextDecoration? textDecoration}) {
    return getTextStyle(fontSize, color, fontWeight ?? AppFontWeight.semiBold,
        AppFontFamily.fontMontserrat,
        textDecoration: textDecoration);
  }

  static const normalWhite_12 = TextStyle(
    fontSize: AppFontSize.size_12,
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontFamily: 'Cairo',
  );
}
