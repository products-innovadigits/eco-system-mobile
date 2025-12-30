
import 'package:pms_system/core/utility/pms_exports.dart';
import '../../../shared/widgets/project_risks.dart';

class ProjectReportRisks extends StatelessWidget {
  final List<MobileRiskModel> reportRisks;

  const ProjectReportRisks({super.key, required this.reportRisks});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.risks),
      withMargin: false,
      withExpanded: false,
      child: ProjectRisks(risksList: reportRisks),
    );
  }
}
