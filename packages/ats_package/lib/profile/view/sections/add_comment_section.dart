import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class AddCommentSection extends StatelessWidget {
  final TextEditingController commentController;
  final Function(String) onCommentAdded;

  const AddCommentSection(
      {super.key,
      required this.commentController,
      required this.onCommentAdded});

  @override
  Widget build(BuildContext context) {
    return commentController.text.isNotEmpty
        ? Row(
            children: [
              Text('${allTranslations.text(LocaleKeys.comment)}:',
                  style: AppTextStyles.w600
                      .copyWith(fontSize: 10, color: Styles.PRIMARY_COLOR)),
              Text(commentController.text,
                  style: AppTextStyles.w400.copyWith(
                      fontSize: 10, color: Styles.SUB_TEXT_DARK_COLOR))
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
                    8.sw,
                    Text(allTranslations.text(LocaleKeys.add_comment),
                        style: AppTextStyles.w400.copyWith(
                            fontSize: 12, color: Styles.PRIMARY_COLOR)),
                  ],
                ),
              );
            },
          );
  }
}
