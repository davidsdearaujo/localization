import 'localization_service.dart';

extension LocalizationExtension on String {
  String i18n([List<String> arguments = const []]) {
    return LocalizationService.instance.read(this, arguments);
  }
}
