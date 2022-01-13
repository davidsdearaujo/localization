import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:localization/colored_print/colored_print.dart';

extension Localization on String {
  static Map<String, String>? sentences;
  static String? selectedLanguage;
  static String? defaultLang;
  static List<String>? translationLocales;
  static bool? showDebugPrintMode;

  static setShowDebugPrintMode(bool value) => showDebugPrintMode = value;

  static Future<String> _readFullLanguageFile(String pathLocale, String language) async {
    final data = await rootBundle.loadString('$pathLocale/$language.json');
    return data;
  }

  static Future<String> _readLanguageFileWithoutCountry(String pathLocale, String language) async {
    final onlyLanguage = language.split('_').first;
    final data = await rootBundle.loadString('$pathLocale/$onlyLanguage.json');
    return data;
  }

  static Future<String> _readDefaultLanguageFile(String pathLocale, String? defaultLang) async {
    final data = await rootBundle.loadString('$pathLocale/${defaultLang ?? 'pt_BR'}.json');
    return data;
  }

  static Future<String?> _readLanguageFile(String pathLocale, String language, String? defaultLanguage) async {
    String? data;
    try {
      data = await _readFullLanguageFile(pathLocale, language);
    } catch (ex, stack) {
      try {
        data = await _readLanguageFileWithoutCountry(pathLocale, language);
      } catch (ex2, stack2) {
        data = await _readDefaultLanguageFile(pathLocale, defaultLanguage);
      }
    }
    return data;
  }

  static Future<void> configuration({
    @deprecated String? translationLocale,
    String? defaultLang,
    String? selectedLanguage,
    bool showDebugPrintMode = true,
  }) async {
    Localization.showDebugPrintMode = showDebugPrintMode;
    if (translationLocale != null)
      includeTranslationDirectory(translationLocale);
    ColoredPrint.log('Carregando dados de localização.');
    if (Localization.translationLocales == null) {
      final message =
          'Execute o método "Localization.includeTranslationDirectory()';
      ColoredPrint.error(message);
      throw '[Localization System] $message';
    }
    Localization.sentences = {};
    for (var locale in Localization.translationLocales!) {
      String data;
      try {
        selectedLanguage = selectedLanguage ?? window.locale.toString();
        data = (await _readLanguageFile(locale, selectedLanguage, defaultLang))!;

        Map<String, dynamic> _result = json.decode(data);
        for (var entry in _result.entries) {
          if (Localization.sentences?.containsKey(entry.key) ?? false) {
            ColoredPrint.warning(
                'Duplicated Key: \"${entry.key}\" Path: \"$locale\"');
          }
          Localization.sentences![entry.key] = entry.value.toString();
        }
        ColoredPrint.log("Carregadas keys do path $locale");
      } catch (_) {
        ColoredPrint.error("Erro ao carregar as keys do path $locale");
      }
    }
    if (selectedLanguage != null)
      Localization.selectedLanguage = selectedLanguage;
    if (defaultLang != null) Localization.defaultLang = defaultLang;
    ColoredPrint.success("Dados de localização carregados com sucesso!");
    ColoredPrint.show("Finalização da configurção");
  }

  static void setTranslationDirectories(List<String> translationLocales) async {
    Localization.translationLocales = translationLocales;
    ColoredPrint.log("Adicionados Paths: $translationLocales");
  }

  static void includeTranslationDirectory(String translationLocale) async {
    if (Localization.translationLocales == null)
      Localization.translationLocales = [];
    Localization.translationLocales!.add(translationLocale);
    ColoredPrint.log("Adicionado Path: $translationLocale");
  }

  static String translate(String key,
          {List<String>? args, List<bool>? conditions}) =>
      key.i18n(args: args, conditions: conditions);
  String i18n({List<String>? args, List<bool>? conditions}) {
    final key = this;
    if (Localization.sentences == null) {
      final message = "Nenhuma chave de tradução encontrada. "
          "Tente executar o método Localization.configuration() antes de buscar alguma tradução.";
      ColoredPrint.error(message);
      throw '[Localization System] $message';
    }

    String? res = Localization.sentences![key];
    if (res != null && args != null) {
      for (var arg in args) {
        res = res!.replaceFirst(RegExp(r'%s'), arg.toString());
      }
    }
    if (res != null && conditions != null) {
      var matches = _getConditions(res);
      if (matches.length != conditions.length) {
        final message =
            "A Quantidade de condicionais configurada na chave não condiz com os parametros.";
        ColoredPrint.error(message);
        throw '[Localization System] $message';
      }

      res = _replaceConditions(matches, conditions, res);
    }

    return res ?? key;
  }

  Iterable<RegExpMatch> _getConditions(String text) {
    String pattern = r"%b\{(\s*?.*?)*?\}";
    RegExp regExp = new RegExp(
      pattern,
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.hasMatch(text)) {
      var matches = regExp.allMatches(text);
      return matches;
    }

    return [];
  }

  String _replaceConditions(
      Iterable<RegExpMatch> matches, List<bool> plurals, String text) {
    var newText = text;
    int i = 0;

    for (var item in matches) {
      var replaced = item.group(0) ?? '';

      RegExp regCondition = new RegExp(
        r'(?<=\{)(.*?)(?=\})',
        caseSensitive: false,
        multiLine: false,
      );
      var e = regCondition.stringMatch(replaced)?.split(':');
      var n = plurals[i] ? e![0] : e![1];

      newText = newText.replaceAll(replaced, n);

      i++;
    }

    return newText;
  }

  static void fromJson(Map<String, dynamic> json) => Localization.sentences =
      json.map((key, value) => MapEntry(key, value.toString()));

  static Map<String, String>? toJson() => Localization.sentences;
}
