import 'package:fpdart/fpdart.dart';
import 'package:localization_ui/src/home/domain/entities/language_file.dart';
import 'package:localization_ui/src/home/domain/errors/errors.dart';
import 'package:localization_ui/src/home/domain/services/file_service.dart';

typedef ReadJsonCallback = Future<Either<FileServiceError, List<LanguageFile>>>;

abstract class ReadJson {
  ReadJsonCallback call(String directory);
}

class ReadJsonImpl implements ReadJson {
  final FileService _service;

  ReadJsonImpl(this._service);

  @override
  ReadJsonCallback call(String directory) async {
    return await _service.getLanguages(directory);
  }
}
