import 'package:core_system/core/core/app_strings/locale_keys.dart';
import 'package:core_system/core/helpers/translation/all_translation.dart';

class ProjectManagementUtility {
  static String projectStatusText(String status) {
    switch (status) {
      case "Completed":
        return allTranslations.text(LocaleKeys.completed);
      case "InProgress":
        return allTranslations.text(LocaleKeys.in_progress);
      case "Upcoming":
        return allTranslations.text(LocaleKeys.upcoming);
      case "Delayed":
        return allTranslations.text(LocaleKeys.late);
      default:
        return status;
    }
  }
}
