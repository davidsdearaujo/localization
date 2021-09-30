import 'package:flutter/widgets.dart';

import 'print_color.dart';

class ColoredPrint {
  static void success(msg) => log(msg, tagColor: PrintColor.green);
  static void error(msg) => log(msg, tagColor: PrintColor.red);
  static void warning(msg) => log(msg, tagColor: PrintColor.yellow);
  static show(msg, {PrintColor messageColor = PrintColor.white}) =>
      log(msg, messageColor: messageColor, tag: "");
  static void log(
    String message, {
    String tag = "Localization System",
    PrintColor tagColor = PrintColor.grey,
    PrintColor messageColor = PrintColor.white,
  }) {
    var content = "";
    if (tag.isNotEmpty) content += tagColor("[$tag] ");
    content += messageColor(message);
    debugPrint(content);
  }
}
