import 'package:flutter/material.dart';

extension ScrollExtention on ScrollController {
  bool get reachTop {
    return hasClients && offset >= 100.0;
  }
}
