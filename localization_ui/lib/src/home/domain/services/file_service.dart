import 'package:localization_ui/src/home/domain/entities/language_file.dart';

import '../usecases/read_json.dart';
import '../usecases/save_json.dart';

abstract class FileService {
  ReadJsonCallback getLanguages(String directory);
  SaveJsonCallback saveLanguages(List<LanguageFile> languages);
}
