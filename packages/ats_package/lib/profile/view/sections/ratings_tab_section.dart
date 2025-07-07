import 'package:ats_package/profile/view/sections/manager_details_review_section.dart';
import 'package:ats_package/profile/view/widgets/compatibility_percentage_widget.dart';
import 'package:core_package/core/utility/export.dart';

class RatingsSection extends StatelessWidget {
  const RatingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ManagersReviewsListSection(),
        16.sh,
        CompatibilityPercentageWidget(
            title: allTranslations.text(LocaleKeys.final_evaluation),
            percentage: 80)
      ],
    );
  }
}
