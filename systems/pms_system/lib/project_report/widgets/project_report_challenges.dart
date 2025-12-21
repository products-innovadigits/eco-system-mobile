import 'package:pms_system/project_details/widgets/project_challenges.dart';

import '../../shared/pms_exports.dart';

class ProjectReportChallenges extends StatelessWidget {
  final List<MobileChallengeItemModel> challengesList;

  const ProjectReportChallenges({super.key, required this.challengesList});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.the_challenges),
      withMargin: false,
      withExpanded: false,
      subTitle:
          '${challengesList.length} ${allTranslations.text(LocaleKeys.challenge)}',
      child: ProjectChallenges(challenges: challengesList),
    );
  }
}
