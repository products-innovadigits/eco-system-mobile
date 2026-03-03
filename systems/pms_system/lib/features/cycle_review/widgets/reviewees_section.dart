import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';
import 'package:pms_system/features/cycle_review/widgets/reviewee_card.dart';

class RevieweesSection extends StatelessWidget {
  final List<CycleRevieweeModel> reviewees;

  const RevieweesSection({super.key, required this.reviewees});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              allTranslations.text(LocaleKeys.reviewees),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            InkWell(
              onTap: () {},
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
          reviewees.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: ReviewCard(
              review: reviewees[index],
              initiallyExpanded: index == 0,
            ),
          ),
        ),
      ],
    );
  }
}
