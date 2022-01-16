import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:localization_ui/home/domain/entities/language_file.dart';
import 'package:localization_ui/home/domain/errors/errors.dart';
import 'package:localization_ui/home/domain/services/file_service.dart';
import 'package:localization_ui/home/domain/usecases/save_json.dart';
import '../../domain/usecases/read_json.dart';

class FileServiceImpl implements FileService {
  @override
  ReadJsonCallback getLanguages(String path) async {
    try {
      final directory = Directory(path);
      final languages = <LanguageFile>[];
      final streamFile = directory.list().where((file) {
        return file.path.endsWith('.json');
      });
      await for (var file in streamFile) {
        if (file is File) {
          var json = jsonDecode(await file.readAsString());
          json = json.cast<String, String>();
          final language = LanguageFile(file, json);
          languages.add(language);
        }
      }
      return Right(languages);
    } on FileSystemException catch (e, s) {
      if (e.osError?.errorCode == 2) {
        return Left(NotFoundFiles('Erro na leitura dos arquivos json', s));
      }
      rethrow;
    }
  }

  @override
  SaveJsonCallback saveLanguages(List<LanguageFile> languages) async {
    for (var language in languages) {
      await _saveFile(language);
    }

    return Right(unit);
  }

  Future<void> _saveFile(LanguageFile language) async {
    final buff = StringBuffer();
    final keys = language.keys;
    if (keys.isEmpty) {
      buff.write('{');
    } else {
      buff.writeln('{');
    }

    for (var i = 0; i < keys.length; i++) {
      final key = keys[i];
      final value = language.read(key);
      buff.write('  \"$key\": \"$value\"');
      if (i != (keys.length - 1)) {
        buff.write(',');
      }
      buff.write('\n');
    }

    buff.write('}');

    await language.file.writeAsString(buff.toString());
  }
}
