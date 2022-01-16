import 'package:localization_ui/home/domain/entities/language_file.dart';
import 'package:localization_ui/home/domain/errors/errors.dart';

abstract class FileState {
  final String? directory;
  final List<LanguageFile> languages;

  const FileState({this.directory, this.languages = const []});

  FileState setDirectoryAndLoad(String directory) => LoadingFileState(directory: directory, languages: this.languages);
  FileState loadedLanguages([List<LanguageFile>? languages]) => LoadedFileState(
        directory: this.directory,
        languages: languages ?? this.languages,
      );
  FileState setLoading() => LoadingFileState(directory: this.directory, languages: this.languages);
  FileState setError(FileServiceError error) => ErrorFileState(
        error: error,
        directory: this.directory,
        languages: this.languages,
      );
}

class InitFileState extends FileState {}

class ErrorFileState extends FileState {
  final FileServiceError error;

  const ErrorFileState({required this.error, String? directory, required List<LanguageFile> languages})
      : super(
          directory: directory,
          languages: languages,
        );
}

class LoadingFileState extends FileState {
  const LoadingFileState({String? directory, required List<LanguageFile> languages})
      : super(
          directory: directory,
          languages: languages,
        );
}

class LoadedFileState extends FileState {
  const LoadedFileState({required String? directory, required List<LanguageFile> languages})
      : super(
          directory: directory,
          languages: languages,
        );
}
