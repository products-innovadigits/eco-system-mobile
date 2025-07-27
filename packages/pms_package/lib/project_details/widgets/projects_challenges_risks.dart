import 'package:pms_package/project_details/widgets/challenge_risk_card_widget.dart';

import '../../shared/pms_exports.dart';

class ProjectsChallengesRisks extends StatelessWidget {
  const ProjectsChallengesRisks({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 2.5,
      ),
      children: [
        ChallengeRiskCardWidget(
            title: allTranslations.text(LocaleKeys.current_salary),
            value: '2000\$',
            isPrimaryColor: true),
        ChallengeRiskCardWidget(
          title: allTranslations.text(LocaleKeys.current_salary),
          value: '3000\$',
        ),
        ChallengeRiskCardWidget(
            title: allTranslations.text(LocaleKeys.current_salary),
            value: '2000\$',
            isPrimaryColor: true),
        ChallengeRiskCardWidget(
            title: allTranslations.text(LocaleKeys.current_salary),
            value: '3000\$'),
      ],
    );
  }
}
