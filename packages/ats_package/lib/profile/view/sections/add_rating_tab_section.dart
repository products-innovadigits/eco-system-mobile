import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class AddRatingTabSection extends StatelessWidget {
  const AddRatingTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        final ratingItems = profileBloc.ratingItems;

        return Stack(
          children: [
            Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ratingItems.length,
                  separatorBuilder: (_, __) => 16.sh,
                  itemBuilder: (_, index) {
                    final item = ratingItems[index];
                    final controller =
                        TextEditingController(text: item.comment);

                    return CustomRatingSection(
                      title: allTranslations.text(item.title),
                      selectedRating: item.rating,
                      isCommentVisible: item.isCommentFieldVisible,
                      comment: item.comment,
                      onRatingSelected: (rate) => profileBloc
                          .add(UpdateRating(index: index, rating: rate)),
                      onCommentAdded: (comment) => profileBloc
                          .add(AddComment(index: index, comment: comment)),
                      onToggleCommentField: () =>
                          profileBloc.add(ToggleCommentField(index: index)),
                      controller: controller,
                    );
                  },
                ),
                70.sh,
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomBtn(
                    text: allTranslations.text(LocaleKeys.save),
                    onPressed: () => CustomNavigator.pop()))
          ],
        );
      },
    );
  }
}
