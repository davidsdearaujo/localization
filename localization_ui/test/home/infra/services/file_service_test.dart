import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:localization_ui/src/home/domain/entities/language_file.dart';
import 'package:localization_ui/src/home/domain/errors/errors.dart';
import 'package:localization_ui/src/home/infra/services/file_service.dart';

class FileFake extends Fake implements File {
  String text = '';

  Future<File> writeAsString(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) async {
    text = contents;
    return this;
  }
}

void main() {
  late FileServiceImpl service;
  late FileFake file;

  setUp(() {
    service = FileServiceImpl();
    file = FileFake();
  });

  group('read json', () {
    test('Read json files', () async {
      final result = await service.getLanguages('./test/jsons');
      final list = result.getOrElse((l) => []);
      expect(list.length, 2);
    });

    test('thows NotFoundFiles if not found path directory', () async {
      final result = await service.getLanguages('./unknow');
      expect(result.fold(id, id), isA<NotFoundFiles>());
    });
  });

  test('Save json files', () async {
    final language = LanguageFile(file, {'hello-text': 'Hello', 'name': 'Jacob'});

    final result = await service.saveLanguages([language]);
    expect(result.isRight(), true);
    expect(file.text, '''{
  "hello-text": "Hello",
  "name": "Jacob"
}''');
  });
}
