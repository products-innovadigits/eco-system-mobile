import 'package:pms_system/project_details/widgets/risk_challenge_card_widget.dart';
import 'package:pms_system/project_report/widgets/custom_info_container_widget.dart';

import '../../shared/pms_exports.dart';

class ProjectReportChallenges extends StatelessWidget {
  final List<ProjectReportChallengeModel> challengesList;

  const ProjectReportChallenges({super.key, required this.challengesList});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.the_challenges),
      withMargin: false,
      withExpanded: false,
      action: CustomInfoContainerWidget(
        color: context.color.error,
        title:
            '${challengesList.length} ${challengesList.length > 10 ? allTranslations.text(LocaleKeys.challenge) : allTranslations.text(LocaleKeys.challenges)}',
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 2.5,
        ),
        children: List.generate(challengesList.length, (index) {
          final challenge = challengesList[index];
          return RiskChallengeCardWidget(
            title: challenge.challengeName ?? '',
            value: '10',
            // value: challenge.value.toString(),
            color: Color(int.parse(('#175CD3').replaceFirst('#', '0xff'))),
          );
        }),
      ),
    );
  }
}
