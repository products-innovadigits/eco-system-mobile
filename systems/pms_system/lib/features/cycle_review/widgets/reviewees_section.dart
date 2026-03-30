import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';
import 'package:pms_system/features/cycle_review/widgets/reviewee_card.dart';

class ReviewersSection extends StatelessWidget {
  final List<CycleRevieweeModel> reviewers;
  final int? cycleId;
  final int totalReviewees;

  const ReviewersSection({
    super.key,
    required this.reviewers,
    this.cycleId,
    required this.totalReviewees,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  allTranslations.text(LocaleKeys.reviewers),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '($totalReviewees)',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.color.outlineVariant,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                if (cycleId != null) {
                  CustomNavigator.push(
                    Routes.CYCLE_REVIEWEES,
                    arguments: cycleId,
                  );
                }
              },
              child: Text(
                allTranslations.text(LocaleKeys.view_all),
                style: context.textTheme.bodySmall?.copyWith(
                  color: LightColor.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...List.generate(
          reviewers.length > 3 ? 3 : reviewers.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: ReviewCard(
              review: reviewers[index],
              initiallyExpanded: index == 0,
            ),
          ),
        ),
      ],
    );
  }
}
