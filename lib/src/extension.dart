import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

extension Localization on String {
  static Map<String, String> sentences;

  static Future<void> configuration({
    String translationLocale = "assets/lang",
    String defaultLang = "pt_BR",
  }) async {
    String data;
    debugPrint("Carregando dados de localização.");
    try {
      data = await rootBundle
          .loadString('$translationLocale/${Platform.localeName}.json');
    } catch (_) {
      data =
          await rootBundle.loadString('$translationLocale/$defaultLang.json');
    }
    Map<String, dynamic> _result = json.decode(data);

    sentences = Map();
    _result.forEach((String key, dynamic value) {
      sentences[key] = value.toString();
    });
    debugPrint("Dados de localização carregados com sucesso!");
  }

  String i18n([List<String> args]) {
    final key = this;
    if (sentences == null) {
      throw "[Localization System] sentences = null";
    }
    String res = sentences[key];
    if (res == null) {
      res = key;
    } else {
      if (args != null) {
        args.forEach((arg) {
          res = res.replaceFirst(RegExp(r'%s'), arg.toString());
        });
      }
    }
    return res;
  }

  static void fromJson(Map<String, dynamic> json) => sentences = json;

  Map<String, String> toJson() => sentences;
}
