import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  bool get isLightMode => Theme.of(this).brightness == Brightness.dark;

  Color get transparent => Colors.transparent;

  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  bool get isSmallScene => MediaQuery.of(this).size.width <= 340;
  bool get isMediumScene => MediaQuery.of(this).size.width <= 375;
}
