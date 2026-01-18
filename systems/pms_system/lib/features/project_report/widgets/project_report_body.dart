import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectReportBody extends StatelessWidget {
  final ProjectReportDataModel model;
  final int projectId;

  const ProjectReportBody({
    super.key,
    required this.model,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (model.details?.projectName != null)
            ProjectReportName(
              name: model.details?.projectName ?? '',
              status: model.status ?? '',
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              spacing: 16,
              children: [
                if (model.details != null)
                  ProjectReportSummary(reportDetails: model.details!),
                ProjectReportDescription(
                  description: model.details?.description ?? '',
                  category: model.details?.categoryName ?? '',
                ),
                ProjectReportInitiativesAndKpis(
                  initiativesAndKpis: model.relatedItems ?? [],
                ),
                if (model.budget != null && model.budget!.isNotEmpty)
                  ProjectReportFundingChart(
                    data: model.budget!
                        .map(
                          (e) => ProjectsOverviewData(
                            name: e.label,
                            percentage: e.percent,
                            count: e.amount,
                            hexColor: e.background,
                          ),
                        )
                        .toList(),
                    projectBudget:
                        model.details?.approvedBudget?.toDouble() ?? 0,
                  ),
                GeneralProgressSection(
                  projectId: projectId,
                  withFiltration: false,
                ),
                if (model.activitiesPercent != null)
                  ProjectReportActivitiesChart(
                    activities: model.activitiesPercent?.bars ?? [],
                    totalActivities: model.activitiesCount ?? 0,
                  ),
                ProjectReportOutputs(
                  outputsSummary: model.outputsSummary ?? [],
                ),
                if (model.challenges != null)
                  ProjectReportChallenges(
                    challengesList: model.challenges?.items ?? [],
                  ),
                if (model.risks != null)
                  ProjectReportRisks(reportRisks: model.risks ?? []),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
