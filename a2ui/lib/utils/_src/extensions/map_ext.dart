import 'dart:convert';
import 'dart:developer';

extension MapExt on Map {
  logToDebugConsole({String? name}) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    log(" ${encoder.convert(this)}", name: name ?? '');
  }
}
