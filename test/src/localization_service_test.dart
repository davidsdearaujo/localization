import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization/src/localization_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalizationService.instance.showDebugPrintMode = false;
  });

  tearDown(() {
    LocalizationService.instance.clearSentences();
  });

  group('Read', () {
    test('Read', () {
      LocalizationService.instance.addSentence('full-name', 'Jacob Moura');
      final value = LocalizationService.instance.read('full-name', []);
      expect(value, 'Jacob Moura');
    });

    test('Read with 1 arguments', () {
      LocalizationService.instance.addSentence('full-name', 'Jacob %s');
      var value = LocalizationService.instance.read('full-name', ['Araujo']);
      expect(value, 'Jacob Araujo');

      value = LocalizationService.instance.read('full-name', ['Moura']);
      expect(value, 'Jacob Moura');
    });

    test('Read with 2 arguments', () {
      LocalizationService.instance.addSentence('full-name-complete', 'Jacob %s %s');

      var value = LocalizationService.instance.read('full-name-complete', ['Araujo', 'Moura']);
      expect(value, 'Jacob Araujo Moura');
    });

    test('Read with positional arguments', () {
      LocalizationService.instance.addSentence('full-name-complete-positional', 'Jacob %s1 %s0');

      var value = LocalizationService.instance.read('full-name-complete-positional', ['Araujo', 'Moura']);
      expect(value, 'Jacob Moura Araujo');
    });

    test('Read with positional arguments out range', () {
      LocalizationService.instance.addSentence('full-name-complete-positional', 'Jacob %s0 %s1 %s9');

      var value = LocalizationService.instance.read('full-name-complete-positional', ['Araujo', 'Moura']);
      expect(value, 'Jacob Araujo Moura %s9');
    });
  });

  group('json file', () {
    test('load en_US', () async {
      await LocalizationService.instance.changeLanguage(Locale('en', 'US'), 'test/assets/lang');
      var value = LocalizationService.instance.read('login-label', []);
      expect(value, 'User');
      value = LocalizationService.instance.read('home-title', ['Flutterando']);
      expect(value, 'Localization Test - Flutterando');
    });
  });
}
