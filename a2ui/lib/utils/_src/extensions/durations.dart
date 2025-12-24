extension DurationExtension on Duration {
  String formatString() {
    if (inHours > 0) return formatHHMMSS();
    return formatMMSS();
  }

  String formatHHMMSS() {
    return '$this'.split('.')[0].padLeft(8, '0');
  }

  String formatMMSS() {
    final p = '$this'.split('.')[0].padLeft(8, '0').split(':');
    return "${p[1]}:${p[2]}";
  }
}
