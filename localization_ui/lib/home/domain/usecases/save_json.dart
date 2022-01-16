import 'package:fpdart/fpdart.dart';
import 'package:localization_ui/home/domain/entities/language_file.dart';
import 'package:localization_ui/home/domain/errors/errors.dart';
import 'package:localization_ui/home/domain/services/file_service.dart';

typedef SaveJsonCallback = Future<Either<FileServiceError, Unit>>;

abstract class SaveJson {
  SaveJsonCallback call(List<LanguageFile> languages);
}

class SaveJsonImpl implements SaveJson {
  final FileService _service;

  SaveJsonImpl(this._service);

  @override
  SaveJsonCallback call(List<LanguageFile> languages) async {
    return await _service.saveLanguages(languages);
  }
}
