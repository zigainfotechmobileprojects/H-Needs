import 'package:hneeds_user/utill/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  // primaryColor: const Color(0xFF9675c4),
  primaryColor: const Color(0xff16723A),
  secondaryHeaderColor: const Color(0xFFefe6fc),
  brightness: Brightness.dark,
  cardColor: const Color(0xFF29292D),
  hintColor: const Color(0xFFE7F6F8),
  focusColor: const Color(0xFFC3CAD9),
  shadowColor: Colors.black.withOpacity(0.4),
  popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  // dialogTheme:  DialogTheme(surfaceTintColor: Colors.white10),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    background: const Color(0xFF212121),
    onBackground: const Color(0xFFC3CAD9),
    primary: const Color(0xFF9675c4),
    onPrimary: const Color(0xFF9675c4),
    secondary: const Color(0xFFefe6fc),
    onSecondary: const Color(0xFFefe6fc),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white10,
    onSurface: Colors.white70,
    shadow: Colors.black.withOpacity(0.4),
  ),
);
