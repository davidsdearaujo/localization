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

  static Future<void> configuration({@deprecated String? translationLocale, String? defaultLang, String? selectedLanguage}) async {
    if (translationLocale != null) includeTranslationDirectory(translationLocale);
    ColoredPrint.log('Carregando dados de localização.');
    if (Localization.translationLocales == null) {
      final message = 'Execute o método "Localization.includeTranslationDirectory()';
      ColoredPrint.error(message);
      throw '[Localization System] $message';
    }
    Localization.sentences = {};
    for (var locale in Localization.translationLocales!) {
      String data;
      try {
        selectedLanguage = selectedLanguage ?? window.locale.toString();
        data = await rootBundle
            .loadString('$locale/$selectedLanguage.json')
            .onError((error, stackTrace) => rootBundle.loadString('$locale/${defaultLang ?? 'pt_BR'}.json'));

        Map<String, dynamic> _result = json.decode(data);
        for (var entry in _result.entries) {
          if (Localization.sentences?.containsKey(entry.key) ?? false) {
            ColoredPrint.warning('Duplicated Key: \"${entry.key}\" Path: \"$locale\"');
          }
          Localization.sentences![entry.key] = entry.value.toString();
        }
        ColoredPrint.log("Carregadas keys do path $locale");
      } catch (_) {
        ColoredPrint.error("Erro ao carregar as keys do path $locale");
      }
    }
    if (selectedLanguage != null) Localization.selectedLanguage = selectedLanguage;
    if (defaultLang != null) Localization.defaultLang = defaultLang;
    ColoredPrint.success("Dados de localização carregados com sucesso!");
  }

  static void setTranslationDirectories(List<String> translationLocales) async {
    Localization.translationLocales = translationLocales;
    ColoredPrint.log("Adicionados Paths: $translationLocales");
  }

  static void includeTranslationDirectory(String translationLocale) async {
    if (Localization.translationLocales == null) Localization.translationLocales = [];
    Localization.translationLocales!.add(translationLocale);
    ColoredPrint.log("Adicionado Path: $translationLocale");
  }

  static String translate(String key, [List<String>? args]) => key.i18n(args);
  String i18n([List<String>? args]) {
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

    return res ?? key;
  }

  static void fromJson(Map<String, dynamic> json) => Localization.sentences = json.map((key, value) => MapEntry(key, value.toString()));

  Map<String, String>? toJson() => Localization.sentences;
}
