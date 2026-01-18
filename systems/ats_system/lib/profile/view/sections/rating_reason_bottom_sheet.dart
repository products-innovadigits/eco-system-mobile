import 'package:core_system/core/utility/export.dart';

class RatingReasonBottomSheet extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onCommentAdded;
  const RatingReasonBottomSheet({
    super.key,
    required this.commentController,
    required this.onCommentAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(title: allTranslations.text(LocaleKeys.add_comment)),
        SizedBox(height: 24.h),
        CustomTextField(
          hint: '${allTranslations.text(LocaleKeys.add_reason)}...',
          label: allTranslations.text(LocaleKeys.reason),
          controller: commentController,
          maxLines: 5,
        ),
        SizedBox(height: 16.h),
        CustomBtn(
          text: allTranslations.text(LocaleKeys.save),
          onPressed: () {
            onCommentAdded.call(commentController.text);
            commentController.clear();
            CustomNavigator.pop();
          },
        ),
      ],
    );
  }
}
