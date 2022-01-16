import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:localization_ui/home/domain/entities/language_file.dart';

void main() {
  test('name and nameWithoutExtension', () {
    final entity = LanguageFile(File('assets/pt.json'), {});

    expect(entity.name, 'pt.json');
    expect(entity.nameWithoutExtension, 'pt');
  });
}
