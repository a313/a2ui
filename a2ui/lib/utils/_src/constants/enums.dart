import 'dart:ui';

import 'package:a2ui/theme/app_colors.dart';

enum SnackBarType { info, success, error, warning }

extension SnackBarTypeExt on SnackBarType {
  Color get textColor {
    switch (this) {
      case SnackBarType.info:
        return AppColors.g300;
      case SnackBarType.success:
        return AppColors.p300;
      case SnackBarType.error:
        return AppColors.r300;
      case SnackBarType.warning:
        return AppColors.o300;
    }
  }

  String get icon {
    switch (this) {
      case SnackBarType.info:
        return "assets/svg/Info.svg";
      case SnackBarType.success:
        return "assets/svg/Check.svg";
      case SnackBarType.error:
        return "assets/svg/WarningCircle.svg";
      case SnackBarType.warning:
        return 'assets/svg/Warning.svg';
    }
  }

  Color get bgColor {
    switch (this) {
      case SnackBarType.info:
        return AppColors.g50;
      case SnackBarType.success:
        return AppColors.p50;
      case SnackBarType.error:
        return AppColors.r50;
      case SnackBarType.warning:
        return AppColors.o50;
    }
  }
}
