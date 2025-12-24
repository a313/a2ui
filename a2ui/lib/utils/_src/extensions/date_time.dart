import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/date_format.dart';

extension TimeOfDayExt on TimeOfDay {
  String toStringFormat() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(hour);
    final String minuteLabel = addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }
}

extension DateExtension on DateTime {
  String toStringFormat(String format) {
    return DateFormat(format, "en").format(this);
  }

  String toDefaultFormat({String format = 'LLL dd, yyyy'}) {
    if (sameDayWith(DateTime.now())) {
      return "Today";
    }
    return DateFormat(format, "en").format(this);
  }

  String toDefaultFormatWithTime({String format = 'LLL dd, yyyy, hh:mm a'}) {
    if (sameDayWith(DateTime.now())) {
      return "Today, ${DateFormat('hh:mm a', "en").format(this)}";
    }
    return DateFormat(format, "en").format(this);
  }

  String toUTCFormat() {
    return '${DateFormat(DateFormatter.UTC).format(toUtc())}Z';
  }

  DateTime dateWithoutTime() {
    return DateTime.utc(year, month, day);
  }

  DateTime dateWithoutDay() {
    return DateTime.utc(year, month);
  }

  String toTimeDateString() {
    return DateFormat(DateFormatter.hhmmDDMMYYYY).format(this);
  }

  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end.add(const Duration(seconds: 1)));
  }

  bool sameDayWith(DateTime obj) {
    return year == obj.year && month == obj.month && day == obj.day;
  }

  int get daysInMonth {
    return DateTime(
      year,
      month + 1,
      1,
    ).difference(DateTime(year, month, 1)).inDays;
  }

  String timeBefore() {
    final dif = DateTime.now().difference(this);
    if (dif.inMinutes < 1) {
      return 'Just now';
    } else if (dif.inHours < 1) {
      return '${dif.inMinutes} minutes ago';
    }
    if (dif.inDays < 1) {
      return '${dif.inHours} hours ago';
    }
    if (dif.inDays < 7) {
      return '${dif.inDays} days ago';
    }
    return toDefaultFormat();
  }
}
