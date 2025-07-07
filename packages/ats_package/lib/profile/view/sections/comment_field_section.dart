import 'package:core_package/core/utility/export.dart';

class CommentFieldSection extends StatelessWidget {
  final bool isVisible;
  final TextEditingController controller;
  final String comment;
  final Function(String) onSend;
  final VoidCallback onToggle;

  const CommentFieldSection({
    super.key,
    required this.isVisible,
    required this.controller,
    required this.comment,
    required this.onSend,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      if (comment.isNotEmpty) {
        return Row(
          children: [
            Text('${allTranslations.text(LocaleKeys.comment)}:',
                style: AppTextStyles.w600
                    .copyWith(fontSize: 10, color: Styles.PRIMARY_COLOR)),
            4.sw,
            Text(comment,
                style: AppTextStyles.w400
                    .copyWith(fontSize: 10, color: Styles.SUB_TEXT_DARK_COLOR)),
            4.sw,
            InkWell(
                onTap: () {
                  controller.text = comment;
                  onToggle();
                },
                child: Images(image: Assets.svgs.editOutline.path)),
          ],
        );
      }
      return InkWell(
        onTap: onToggle,
        child: Row(
          children: [
            Images(image: Assets.svgs.addCircle.path),
            8.sw,
            Text(allTranslations.text(LocaleKeys.add_comment),
                style: AppTextStyles.w400
                    .copyWith(fontSize: 12, color: Styles.PRIMARY_COLOR)),
          ],
        ),
      );
    }

    return CustomTextField(
      hint: allTranslations.text(LocaleKeys.add_comment),
      maxLines: 3,
      controller: controller,
      maxSuffixIconHeight: 70.h,
      suffixWidget: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => onSend(controller.text),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Images(
                    image: Assets.svgs.send.path, height: 20.h, width: 20.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
