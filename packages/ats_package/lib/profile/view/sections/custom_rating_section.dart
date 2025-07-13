import 'package:ats_package/profile/view/sections/comment_field_section.dart';
import 'package:ats_package/profile/view/sections/numbers_rating_section.dart';
import 'package:core_package/core/utility/export.dart';

class CustomRatingSection extends StatelessWidget {
  final String title;
  final int selectedRating;
  final bool isCommentVisible;
  final String comment;
  final TextEditingController controller;
  final Function(int) onRatingSelected;
  final Function(String) onCommentAdded;
  final VoidCallback onToggleCommentField;

  const CustomRatingSection({
    super.key,
    required this.title,
    required this.selectedRating,
    required this.onRatingSelected,
    required this.onCommentAdded,
    required this.onToggleCommentField,
    required this.isCommentVisible,
    required this.comment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.color.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${allTranslations.text(LocaleKeys.enter_rating)} $title:',
              style: AppTextStyles.w400.copyWith(fontSize: 11)),
          16.sh,
          NumbersRatingSection(
            selectedRating: selectedRating,
            onRatingSelected: onRatingSelected,
          ),
          if (selectedRating != -1) ...[
            16.sh,
            CommentFieldSection(
              isVisible: isCommentVisible,
              controller: controller,
              comment: comment,
              onSend: onCommentAdded,
              onToggle: onToggleCommentField,
            ),
          ],
        ],
      ),
    );
  }
}

