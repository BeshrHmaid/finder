import 'package:flutter/material.dart';

extension AppColors on ColorScheme {
  // light Theme Colors
  static Color primary = const Color(0xff4C9F97);
  static Color lightPrimaryColor = const Color.fromARGB(255, 114, 215, 205);
  static Color lightSecondaryColor = const Color.fromARGB(255, 152, 248, 238);
  static Color lightAccentColor = const Color(0xff0277FA);
  static Color lightSubHeadingColor1 = const Color(0xff343F53);

  // dark theme color
  static Color darkPrimaryColor = const Color(0xff1E1E2C);
  static Color darkSecondaryColor = const Color(0xff2A2C3E);
  static Color darkAccentColor = const Color(0xff56A4FB);
  static Color darkSubHeadingColor1 = const Color(0xDDF2F1F6);
// Background colors for dark theme
  static const Color background = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color secondaryBackground = Color(0xFF2C2C2C);

  // Text colors for dark theme
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFFB3B3B3);
  static const Color hintText = Color(0xFF8A8A8A);

  // Accent colors
  static const Color accent = Color(0xFF64B5F6);
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);

  // Credibility score colors
  static const Color highCredibility = Color(0xFF4CAF50);
  static const Color mediumCredibility = Color(0xFFFFC107);
  static const Color lowCredibility = Color(0xFFCF6679);

  // when switch color
  Color get blackColor => brightness == Brightness.light
      ? lightSubHeadingColor1
      : darkSubHeadingColor1;
  Color get primaryColor =>
      brightness == Brightness.light ? primary : darkSubHeadingColor1;
  Color get secondaryColor => brightness == Brightness.light
      ? lightSecondaryColor
      : darkSubHeadingColor1;

  Color get themedWhite => brightness == Brightness.light ? white : black;

  Color get themedBlack => brightness == Brightness.light ? black : white;
  static const Color backgroundColor = Color(0xff393937);

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black1c = Color(0xFF1C1C1C);
  static const Color black28 = Color(0xFF282828);
  static const Color black23 = Color(0xFF232323);
  static const Color black14 = Color(0xFF141414);
  static const Color grey9A = Color(0xFF9A9A9A);
  static const Color greyDD = Color(0xFFDDE2E4);
  static const Color grey7F = Color(0xFF7F7F7F);
  static const Color grey9D = Color(0xFFD9D9D9);
  static const Color greyA4 = Color(0xFFA4A4A4);
  static const Color blueFace = Color(0xFF3D5A98);
  static const Color grey89 = Color(0xFF898989);
  static const Color grey8E = Color(0xFF8E8E8E);
  static const Color yellow = Color(0xFFF9C303);
  static const Color grey3B = Color(0xFF3B3B3B);
  static const Color whiteF1 = Color(0xFFF1F1F1);
  static const Color whiteF0 = Color(0xFFF0F0F0);
  static const Color grey72 = Color(0xFF727272);
  static const Color orange = Color(0xFFEC8600);
  static const Color grey3C = Color(0xFF3C3C3C);
  static const Color lightPrimary = Color(0xFF58BA6A);
  static const Color lightOrange = Color(0xFFF4A738);
  static const Color lightRed = Color(0xFFD20808);
  static const Color greyE5 = Color(0xFFE5E5E5);
  static const Color whiteF3 = Color(0xFFF3F3F3);
  static const Color lightXPrimary = Color(0xFFE8FFD0);
  static const Color green = Color(0xFF00B207);
  static const Color lightGreen = Color(0xFF5DFF43);
  static const Color lightYellow = Color(0xFFFFF853);
  static const Color lightXOrange = Color(0xFFE55725);
  static const Color primary7F = Color(0xFF7FFF7C);
  static const Color greyC1 = Color(0xFFC1C1C1);
  static const Color red = Color(0xFFB22222);
  static const Color green32 = Color(0xFF32CD32);
  static const Color greyA9 = Color(0xFFA9A9A9);
  static const Color babyBlue = Color(0xFF87CEEB);
  static const Color greyAD = Color(0xFFADADB4);
  static const Color iconColor = Color(0xFF285781);
}
