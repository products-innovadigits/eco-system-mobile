import 'package:eco_system/utility/export.dart';

class RatingReasonBottomSheet extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onCommentAdded;
  const RatingReasonBottomSheet({super.key, required this.commentController, required this.onCommentAdded});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(title: LocaleKeys.add_comment),
        24.sh,
        CustomTextField(
            hint:
            '${allTranslations.text(LocaleKeys.add_reason)}...',
            label: allTranslations.text(LocaleKeys.reason),
            controller: commentController,
            maxLines: 5),
        16.sh,
        CustomBtn(
            text: allTranslations.text(LocaleKeys.save),
            onPressed: () {
              onCommentAdded.call(commentController.text);
              commentController.clear();
              CustomNavigator.pop();
            })
      ],
    );
  }
}
