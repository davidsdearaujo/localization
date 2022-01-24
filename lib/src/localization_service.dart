import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/colored_print/colored_print.dart';

class LocalizationService {
  static LocalizationService? _instance;
  bool showDebugPrintMode = true;

  static LocalizationService get instance {
    _instance ??= LocalizationService();
    return _instance!;
  }

  final _sentences = <String, String>{};

  Future changeLanguage(Locale locale, String directory) async {
    late String data;
    final selectedLanguage = locale.toString();
    final jsonFile = '$directory/$selectedLanguage.json';

    data = await rootBundle.loadString(jsonFile);
    ColoredPrint.log('Loaded $jsonFile');

    late Map<String, dynamic> _result;

    try {
      _result = json.decode(data);
    } catch (e) {
      ColoredPrint.error(e.toString());
      _result = {};
    }

    clearSentences();

    for (var entry in _result.entries) {
      if (_sentences.containsKey(entry.key)) {
        ColoredPrint.warning('Duplicated Key: \"${entry.key}\" Path: \"$locale\"');
      }
      _sentences[entry.key] = entry.value.toString();
    }
  }

  @visibleForTesting
  void addSentence(String key, String value) {
    _sentences[key] = value;
  }

  String read(String key, List<String> arguments) {
    if (!_sentences.containsKey(key)) {
      return key;
    }
    var value = _sentences[key]!;
    if (value.contains('%s')) {
      return replaceArguments(value, arguments);
    }

    return value;
  }

  String replaceArguments(String value, List<String> arguments) {
    final regExp = RegExp(r'(\%s\d?)');
    final matchers = regExp.allMatches(value);
    var argsCount = 0;

    for (var matcher in matchers) {
      for (var i = 1; i <= matcher.groupCount; i++) {
        final finded = matcher.group(i);
        if (finded == null) {
          continue;
        }

        if (finded == '%s') {
          value = value.replaceFirst('%s', arguments[argsCount]);
          argsCount++;
          continue;
        }

        var extractedId = int.tryParse(finded.replaceFirst('%s', ''));
        if (extractedId == null) {
          continue;
        }

        if (extractedId >= arguments.length) {
          continue;
        }

        value = value.replaceFirst(finded, arguments[extractedId]);
      }
    }

    return value;
  }

  void clearSentences() {
    _sentences.clear();
  }
}
