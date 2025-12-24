import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

extension CustomStringExtension on String {
  static const diacriticsReg =
      'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ|À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ|è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ|È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ|ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ|Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ|ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ|Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ|ì|í|ị|ỉ|ĩ|Ì|Í|Ị|Ỉ|Ĩ|đ|Đ|ỳ|ý|ỵ|ỷ|ỹ|Ỳ|Ý|Ỵ|Ỷ|Ỹ';

  ///Check if string is contain diacritics
  bool get containDiacritics => contains(RegExp(diacriticsReg));

  ///Remove all diacritics of text
  ///
  ///Vi: Xóa toàn bộ dấu khỏi text
  ///
  ///Eg: 'Loại bỏ tiếng việt' -> 'Loai bo tieng viet'
  String removeDiacritics() {
    const vietnamese = 'aAeEoOuUiIdDyY';
    final vietnameseRegex = <RegExp>[
      RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
      RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
      RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
      RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
      RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
      RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
      RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
      RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
      RegExp(r'ì|í|ị|ỉ|ĩ'),
      RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
      RegExp(r'đ'),
      RegExp(r'Đ'),
      RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
      RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ'),
    ];
    var result = this;
    for (var i = 0; i < vietnamese.length; ++i) {
      result = result.replaceAll(vietnameseRegex[i], vietnamese[i]);
    }
    return result;
  }

  bool hasUppercase() {
    final regex = RegExp(r'^(?=.*[A-Z]).*$');
    return regex.hasMatch(this);
  }

  bool hasDigit() {
    final regex = RegExp(r'^(?=.*\d).*$');
    return regex.hasMatch(this);
  }

  bool isValidPassLength() {
    return RegExp(r'^.{8,999}$').hasMatch(this);
  }

  bool isEmailWith(String regex) {
    return RegExp(regex).hasMatch(this);
  }

  bool isValidSpecial() {
    return RegExp('[0-9]|@|#').hasMatch(this);
  }

  bool hasSpecialChar() {
    return RegExp(r'^(?=.*[^a-zA-Z0-9]).*$').hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{8,}$").hasMatch(this);
  }

  bool isVnMobilePhone() {
    return RegExp('(84|0[3|5|7|8|9])+([0-9]{8})').hasMatch(this);
  }

  DateTime toDate(String format) {
    return DateFormat('MM/dd/yyyy').parse(this);
  }

  String convertToPhone() {
    var res = this;
    res = res.replaceAll(RegExp("[^\\d]"), "");
    if (res.startsWith("84")) {
      res = "0${res.substring(2)}";
    }

    res = res.replaceAll('+84', '0');

    if (!res.startsWith('0')) {
      res = '0$res';
    }

    return res;
  }

  int hexToInt() {
    var hexColor = toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  String phoneWithDialCode(String dialCode) {
    var removeSpace = replaceAll(' ', '');
    if (dialCode == "+84") {
      if (removeSpace.startsWith("0")) removeSpace = removeSpace.substring(1);
      var subString = "";
      for (int i = 1; i <= removeSpace.length; i++) {
        if (i % 3 == 0) {
          subString += " ${removeSpace.substring(i - 3, i)}";
        }
      }
      return "($dialCode) $subString";
    } else {
      return "($dialCode) $removeSpace";
    }
  }

  bool get isNumericOnly => _isNumericOnly(this);
  String get onlyNumeric => _numericOnly();

  String _numericOnly({bool firstWordOnly = false}) {
    var numericOnlyStr = '';

    for (var i = 0; i < length; i++) {
      if (_isNumericOnly(this[i])) {
        numericOnlyStr += this[i];
      }
      if (firstWordOnly && numericOnlyStr.isNotEmpty && this[i] == " ") {
        break;
      }
    }

    return numericOnlyStr;
  }

  bool _isNumericOnly(String? value) {
    return (value == null) ? false : RegExp(r'^\d+$').hasMatch(value);
  }

  Size textSize({
    required TextStyle style,
    TextDirection? textDirection = TextDirection.rtl,
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) {
    if (isEmpty) return Size.zero;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: maxLines,
      textDirection: textDirection,
    )..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  String secureBankNumber({int shownIndex = 0}) {
    var input = this;
    var result = '';
    int showRange =
        shownIndex.compareTo(input.length) > 0 ? 0 : input.length - shownIndex;
    int end = shownIndex == 0 ? 0 : showRange;
    String replacement = '•' * end;
    result = input.replaceRange(0, end, replacement);
    return result;
  }

  bool get isYoutubeLink {
    var ext = toLowerCase();

    return ext.contains("https:") &&
        (ext.contains("youtube") || ext.contains("youtu.be"));
  }

  /// Checks if string is an video file.
  bool get isVideoUrl {
    var ext = toLowerCase();

    return ext.endsWith(".mp4") ||
        ext.endsWith(".avi") ||
        ext.endsWith(".mov") ||
        ext.endsWith(".wmv") ||
        ext.endsWith(".rmvb") ||
        ext.endsWith(".mpg") ||
        ext.endsWith(".mpeg") ||
        ext.endsWith(".mkv") ||
        ext.endsWith(".flv") ||
        ext.endsWith(".vob") ||
        ext.endsWith(".ogv") ||
        ext.endsWith(".ogg") ||
        ext.endsWith(".qt") ||
        ext.endsWith(".m4v") ||
        ext.endsWith(".m4p") ||
        ext.endsWith(".hevc") ||
        ext.endsWith(".mpeg4-avc") ||
        ext.endsWith(".3gp");
  }

  /// Checks if string is an image file.
  bool get isImageUrl {
    final ext = toLowerCase();

    return ext.endsWith(".jpg") ||
        ext.endsWith(".jpeg") ||
        ext.endsWith(".png") ||
        ext.endsWith(".gif") ||
        ext.endsWith(".bmp");
  }

  String get svgPath => 'assets/svg/$this.svg';
  String get pngPath => 'assets/png/$this.png';

  String? get convertUrlToYoutubeId {
    if (!contains("http") && (length == 11)) return this;
    for (var exp in [
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$",
      ),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
    ]) {
      Match? match = exp.firstMatch(trim());
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }
}
