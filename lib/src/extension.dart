import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

extension Localization on String {
  static Map<String, String>? sentences;
  static Future<void> configuration({
    String translationLocale = "assets/lang",
    String defaultLang = "pt_BR",
    String? selectedLanguage,
  }) async {
    String data;
    debugPrint(selectedLanguage ?? window.locale.toString());
    debugPrint("Carregando dados de localização.");
    try {
      data = await rootBundle.loadString('$translationLocale/${selectedLanguage ?? window.locale.toString()}.json');
    } catch (_) {
      data = await rootBundle.loadString('$translationLocale/$defaultLang.json');
    }
    Map<String, dynamic> _result = json.decode(data);
    sentences = {};
    _result.forEach((String key, dynamic value) {
      sentences![key] = value.toString();
    });
    debugPrint("Dados de localização carregados com sucesso!");
  }

  String i18n([List<String>? args]) {
    final key = this;

    if (sentences == null) {
      throw '[Localization System] sentences == null.';
    }

    String? res = sentences![key];

    if (res != null) {
      if (args != null) {
        args.forEach((arg) {
          res = res!.replaceFirst(RegExp(r'%s'), arg.toString());
        });
      }
    }

    return res ?? key;
  }

  static void fromJson(Map<String, dynamic> json) =>
      sentences = json.map((key, value) => MapEntry(key, value.toString()));

  Map<String, String>? toJson() => sentences;
}
