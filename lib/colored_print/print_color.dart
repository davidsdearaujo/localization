class PrintColor {
  final String colorMarker;
  static const String resetColorMarker = '\x1B[0m';

  const PrintColor._(this.colorMarker);
  static const red = PrintColor._('\x1B[31m');
  static const green = PrintColor._('\x1B[32m');
  static const white = PrintColor._('\x1B[37m');
  static const yellow = PrintColor._('\x1B[33m');
  static const black = PrintColor._('\x1B[30m');
  static const grey = PrintColor._('\x1B[30m');
  static const blue = PrintColor._('\x1B[34m');
  static const cyan = PrintColor._('\x1B[36m');
  static const magenta = PrintColor._('\x1B[35m');

  String call(String text) => '$colorMarker$text$resetColorMarker';
}
