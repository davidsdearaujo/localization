import 'dart:io';

class LanguageFile {
  final Map<String, String> _dicionary;

  Map<String, String> getMap() => Map<String, String>.unmodifiable(_dicionary);

  String read(String key) => _dicionary[key] ?? '';
  void set(String key, String value) => _dicionary[key] = value;

  List<String> get keys => List<String>.unmodifiable(_dicionary.keys);

  void deleteByKey(String key) => _dicionary.remove(key);

  void setDicionary(Map<String, String> dicionary) {
    _dicionary.clear();
    _dicionary.addAll(dicionary);
  }

  final File file;
  String get name => file.uri.pathSegments.last;
  String get nameWithoutExtension => name.split('.').first;

  const LanguageFile(this.file, this._dicionary);
}
