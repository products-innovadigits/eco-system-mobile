import 'package:core_system/core/core/app_strings/locale_keys.dart';
import 'package:core_system/core/helpers/translation/all_translation.dart';

class ProjectManagementUtility {
  static const _projectStatusKeys = {
    'completed': 'Completed',
    'inprogress': 'InProgress',
    'upcoming': 'Upcoming',
    'delayed': 'Delayed',
  };

  static final _statusSeparators = RegExp(r'[\s_-]');

  /// Normalizes a project status to its enum key.
  ///
  /// Endpoints send either the key (`InProgress`) or the English label
  /// (`In Progress`); both map to the same key so every screen styles a
  /// status the same way. Unknown values are returned trimmed, as-is.
  static String projectStatusKey(String? status) {
    final value = status?.trim() ?? '';
    final normalized = value.replaceAll(_statusSeparators, '').toLowerCase();
    return _projectStatusKeys[normalized] ?? value;
  }

  static String projectStatusText(String status) {
    switch (projectStatusKey(status)) {
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
