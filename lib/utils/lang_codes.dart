import 'package:choco_tur_app_business/utils/logger.dart';

class LanguageCodes {
  static const String EN = "en";
  static const String IT = "it";
  static const String DE = "de";
  static const String FR = "fr";

  static String? langCodeToLabel(String langCode) {
    if (langCode == EN) {
      return "English";
    } else if (langCode == IT) {
      return "Italiano";
    } else if (langCode == DE) {
      return "Deutsch";
    } else if (langCode == FR) {
      return "Française";
    } else {
      LoggerInstance.logger.e('Unknown language code $langCode.');
      return null;
    }
  }
}
