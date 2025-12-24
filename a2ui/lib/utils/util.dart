export '_src/constants/borders.dart';
export '_src/constants/date_format.dart';
export '_src/constants/durations.dart';
export '_src/constants/enums.dart';
export '_src/constants/error_code.dart';
export '_src/constants/paddings.dart';
export '_src/constants/sized_boxs.dart';
export '_src/extensions/app_lifecycle_ext.dart';
export '_src/extensions/build_context.dart';
export '_src/extensions/color_context.dart';
export '_src/extensions/date_time.dart';
export '_src/extensions/durations.dart';
export '_src/extensions/map_ext.dart';
export '_src/extensions/scroll_controller.dart';
export '_src/extensions/string.dart';
export '_src/extensions/string_nullsafety.dart';
export '_src/helper/helper.dart';
export '_src/text_field_formatter/convert_vietnam_char.dart';
export '_src/text_field_formatter/currency_formatter.dart';
export '_src/text_field_formatter/date_input_formatter.dart';
export '_src/text_field_formatter/mask_text_input_formatter.dart';
export '_src/text_field_formatter/max_number_formatter.dart';
export '_src/text_field_formatter/numeric_formatter.dart';
export '_src/text_field_formatter/otp_formatter.dart';
export '_src/text_field_formatter/password_formatter.dart';
export '_src/text_field_formatter/phone_formatter.dart';
export '_src/text_field_formatter/regexp_formmater.dart';
export '_src/text_field_formatter/suffix_formatter.dart';
export '_src/text_field_formatter/upper_case_formatter.dart';
export '_src/text_field_formatter/vn_phone_formatter.dart';

class Utils {
  DateTime minDate(DateTime obj1, DateTime obj2) {
    if (obj2.isAfter(obj1)) return obj1;
    return obj2;
  }

  DateTime maxDate(DateTime obj1, DateTime obj2) {
    if (obj1.isAfter(obj2)) return obj1;
    return obj2;
  }
}
