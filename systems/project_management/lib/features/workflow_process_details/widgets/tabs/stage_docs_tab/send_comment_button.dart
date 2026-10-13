import 'package:project_management/core/utility/project_management_exports.dart';

/// Send icon for comment fields: shows a loader while [isLoading] and is
/// disabled while [controller] holds only whitespace.
class SendCommentButton extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const SendCommentButton({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: context.color.secondary,
          ),
        ),
      );
    }

    // Rebuild only the button while typing, not the whole text field.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final isEmpty = value.text.trim().isEmpty;
        return InkWell(
          onTap: isEmpty ? null : onSend,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Images(
              image: Assets.svgs.send.path,
              color: isEmpty
                  ? context.color.outlineVariant.withValues(alpha: 0.8)
                  : context.color.secondary,
            ),
          ),
        );
      },
    );
  }
}
