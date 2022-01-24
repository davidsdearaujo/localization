import 'package:localization_ui/src/home/domain/entities/language_file.dart';
import 'package:localization_ui/src/home/domain/errors/errors.dart';

abstract class FileState {
  final String? directory;
  final List<LanguageFile> languages;
  final Set<String> keys;

  FileState({this.directory, this.languages = const [], this.keys = const {}});

  FileState setDirectoryAndLoad(String directory) => LoadingFileState(
        directory: directory,
        languages: this.languages,
        keys: this.keys,
      );
  FileState loadedLanguages([List<LanguageFile>? languages]) => LoadedFileState.languages(
        directory: this.directory,
        languages: languages ?? this.languages,
      );
  FileState setLoading() => LoadingFileState(
        directory: this.directory,
        languages: this.languages,
        keys: this.keys,
      );
  FileState setError(FileServiceError error) => ErrorFileState(
        error: error,
        directory: this.directory,
        languages: this.languages,
        keys: this.keys,
      );
}

class InitFileState extends FileState {}

class ErrorFileState extends FileState {
  final FileServiceError error;

  ErrorFileState({
    required this.error,
    String? directory,
    required List<LanguageFile> languages,
    required Set<String> keys,
  }) : super(directory: directory, languages: languages, keys: keys);
}

class LoadingFileState extends FileState {
  LoadingFileState({
    String? directory,
    required List<LanguageFile> languages,
    required Set<String> keys,
  }) : super(directory: directory, languages: languages, keys: keys);
}

class LoadedFileState extends FileState {
  LoadedFileState._({
    required String? directory,
    required List<LanguageFile> languages,
    required Set<String> keys,
  }) : super(directory: directory, languages: languages, keys: keys);

  factory LoadedFileState.languages({
    required String? directory,
    required List<LanguageFile> languages,
  }) {
    final _keys = <String>{};
    for (var langs in languages) {
      _keys.addAll(langs.keys);
    }

    return LoadedFileState._(directory: directory, languages: languages, keys: _keys);
  }
}
