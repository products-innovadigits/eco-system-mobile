import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class AddCommentSection extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onCommentAdded;

  const AddCommentSection({
    super.key,
    required this.commentController,
    required this.onCommentAdded,
  });

  @override
  Widget build(BuildContext context) {
    return commentController.text.isNotEmpty
        ? Row(
            children: [
              Text(
                '${allTranslations.text(LocaleKeys.comment)}:',
                style: AppTextStyles.w600.copyWith(
                  fontSize: 10,
                  color: context.color.primary,
                ),
              ),
              Text(
                commentController.text,
                style: AppTextStyles.w400.copyWith(
                  fontSize: 10,
                  color: Styles.subTextDarkColor,
                ),
              ),
            ],
          )
        : BlocBuilder<ProfileBloc, AppState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  // PopUpHelper.showBottomSheet(
                  //     context: context,
                  //     child: RatingReasonBottomSheet(
                  //       commentController: commentController,
                  //       onCommentAdded: onCommentAdded,
                  //     ));
                },
                child: Row(
                  children: [
                    Images(image: Assets.svgs.addCircle.path),
                    SizedBox(width: 8.w),
                    Text(
                      allTranslations.text(LocaleKeys.add_comment),
                      style: AppTextStyles.w400.copyWith(
                        fontSize: 12,
                        color: context.color.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
