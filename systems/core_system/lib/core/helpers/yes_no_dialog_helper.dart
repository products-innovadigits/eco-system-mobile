import 'package:core_system/core/utility/export.dart';

abstract class YesNoDialogHelper {
  static Future<void> showYesNoDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String yesButtonText,
    required String noButtonText,
    required VoidCallback onYesPressed,
    VoidCallback? onNoPressed,
    Widget? icon,
    Color? yesButtonColor,
    Color? noButtonColor,
    Color? yesButtonTextColor,
    Color? noButtonTextColor,
    Color? yesButtonBorderColor,
    Color? noButtonBorderColor,
    double? buttonHeight,
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title:
              icon ??
              Icon(Icons.help_outline, size: 28, color: context.color.primary),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.outlineVariant,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomBtn(
                    text: yesButtonText,
                    height: buttonHeight ?? 40,
                    color: yesButtonColor ?? context.color.primary,
                    borderColor: yesButtonBorderColor ?? context.color.primary,
                    textColor: yesButtonTextColor ?? context.color.onPrimary,
                    onPressed: () {
                      CustomNavigator.pop();
                      onYesPressed();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomBtn(
                    text: noButtonText,
                    height: buttonHeight ?? 40,
                    color: noButtonColor ?? context.color.surfaceContainer,
                    borderColor: noButtonBorderColor ?? context.color.primary,
                    textColor: noButtonTextColor ?? context.color.primary,
                    onPressed: () {
                      CustomNavigator.pop();
                      onNoPressed?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Convenience method for delete confirmation dialog
  static Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required String itemName,
    required VoidCallback onDeletePressed,
    VoidCallback? onCancelPressed,
  }) {
    return showYesNoDialog(
      context: context,
      title: allTranslations.text(LocaleKeys.delete),
      subtitle: allTranslations.text(LocaleKeys.delete),
      yesButtonText: allTranslations.text(LocaleKeys.delete),
      noButtonText: allTranslations.text(LocaleKeys.cancel),
      icon: Images(image: Assets.svgs.trash.path, width: 28, height: 28),
      yesButtonColor: context.color.error,
      yesButtonTextColor: context.color.onError,
      onYesPressed: onDeletePressed,
      onNoPressed: onCancelPressed,
    );
  }

  /// Convenience method for start process confirmation dialog
  static Future<void> showStartProcessConfirmationDialog({
    required BuildContext context,
    required VoidCallback onStartPressed,
    VoidCallback? onCancelPressed,
  }) {
    return showYesNoDialog(
      context: context,
      title: allTranslations.text(LocaleKeys.confirm_start_process),
      subtitle: allTranslations.text(LocaleKeys.start_process_warning),
      yesButtonText: allTranslations.text(LocaleKeys.yes_start_process),
      noButtonText: allTranslations.text(LocaleKeys.no_later),
      icon: Images(image: Assets.svgs.rocketCircle.path),
      onYesPressed: onStartPressed,
      onNoPressed: onCancelPressed,
    );
  }

  /// Convenience method for close review cycle confirmation
  static Future<void> showCloseReviewCycleConfirmationDialog({
    required BuildContext context,
    required VoidCallback onClosePressed,
    VoidCallback? onCancelPressed,
  }) {
    return showYesNoDialog(
      context: context,
      title: allTranslations.text(LocaleKeys.confirm_close_review_cycle),
      subtitle: allTranslations.text(LocaleKeys.close_review_cycle_warning),
      yesButtonText: allTranslations.text(LocaleKeys.yes_close_review_cycle),
      noButtonText: allTranslations.text(LocaleKeys.no_later),
      icon: Images(image: Assets.svgs.rocketCircle.path),
      onYesPressed: onClosePressed,
      onNoPressed: onCancelPressed,
    );
  }

  /// Convenience method for generic confirmation dialog
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirmPressed,
    VoidCallback? onCancelPressed,
    Widget? icon,
  }) {
    return showYesNoDialog(
      context: context,
      title: title,
      subtitle: message,
      yesButtonText: confirmText,
      noButtonText: cancelText,
      icon: icon,
      onYesPressed: onConfirmPressed,
      onNoPressed: onCancelPressed,
    );
  }
}
