import 'package:a2ui/theme/app_colors.dart';
import 'package:a2ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    textTheme: GoogleFonts.interTextTheme(),
    scaffoldBackgroundColor: AppColors.n0,
    primaryColor: AppColors.p500,
    colorScheme: const ColorScheme.light(
      primary: AppColors.p500,
      secondary: AppColors.p300,
    ),
    disabledColor: AppColors.n40,
    cardColor: AppColors.n0,
    hintColor: AppColors.p500,
    splashColor: AppColors.transparent,

    buttonTheme: const ButtonThemeData(
      height: 40,
      buttonColor: AppColors.p300,
      disabledColor: AppColors.p75,
      hoverColor: AppColors.p300,
      highlightColor: AppColors.p300,
    ),
    appBarTheme: const AppBarTheme().copyWith(
      shadowColor: AppColors.n100,
      color: AppColors.n0,
      elevation: 0.3,
      centerTitle: false,
      titleTextStyle: AppFonts.b16.copyWith(color: AppColors.n900),
      iconTheme: const IconThemeData(color: AppColors.iconColor),
      actionsIconTheme: const IconThemeData(color: AppColors.p300),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    checkboxTheme: CheckboxThemeData().copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.n40),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.p200,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  final darkTheme = ThemeData.dark();
}
