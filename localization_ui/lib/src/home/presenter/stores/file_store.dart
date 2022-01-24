import 'package:flutter/material.dart';
import 'package:localization_ui/src/home/domain/usecases/read_json.dart';
import 'package:localization_ui/src/home/domain/usecases/save_json.dart';
import 'package:localization_ui/src/home/presenter/states/file_state.dart';

class FileStore extends ValueNotifier<FileState> {
  final ReadJson readJson;
  final SaveJson saveJson;

  FileStore(this.readJson, this.saveJson) : super(InitFileState());

  Future<void> setDirectoryAndLoad(String directory) async {
    value = value.setDirectoryAndLoad(directory);
    final result = await readJson.call(directory);
    value = result.fold(value.setError, value.loadedLanguages);
  }

  Future<void> saveLanguages() async {
    value = value.setLoading();
    final result = await saveJson.call(value.languages);
    value = result.fold(value.setError, (r) => value.loadedLanguages());
  }

  void addNewKey(String key) {
    final langs = value.languages;
    for (var lang in langs) {
      lang.set(key, '');
    }

    value = value.loadedLanguages(langs);
  }

  void editKey(String oldKey, String key) {
    final langs = value.languages;
    for (var lang in langs) {
      final newMap = <String, String>{};
      final map = lang.getMap();
      for (var entryKey in map.keys) {
        if (entryKey == oldKey) {
          newMap[key] = map[entryKey]!;
        } else {
          newMap[entryKey] = map[entryKey]!;
        }
      }

      lang.setDicionary(newMap);
    }

    value = value.loadedLanguages(langs);
  }
}
