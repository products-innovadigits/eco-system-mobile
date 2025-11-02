import 'package:pms_system/project_report/widgets/project_report_challenges.dart';
import 'package:pms_system/project_report/widgets/project_report_description.dart';
import 'package:pms_system/project_report/widgets/project_report_name.dart';
import 'package:pms_system/project_report/widgets/project_report_outputs.dart';
import 'package:pms_system/project_report/widgets/project_report_risks.dart';
import 'package:pms_system/project_report/widgets/project_report_summary.dart';
import 'package:pms_system/shared/pms_exports.dart';

import '../../project_details/widgets/project_details_funding_chart.dart';
import 'project_report_activities_chart.dart';

class ProjectReportBody extends StatelessWidget {
  final ProjectReportItemModel model;

  const ProjectReportBody({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProjectReportName(name: model.name ?? '', status: model.status ?? ''),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            spacing: 16,
            children: [
              ProjectReportSummary(model: model),
              ProjectReportDescription(
                description: model.description ?? '',
                status: 'متقدمة',
              ),
              ProjectDetailsFundingChart(
                data: _generateSampleFundingData(
                  // projectDetailsModel.mobileDetails?.budget ?? [],
                ),
                projectBudget: (model.budget ?? 0.0).toDouble(),
              ),
              GeneralProgressSection(
                projectId: model.id ?? 0,
                withFiltration: false,
              ),
              const ProjectReportActivitiesChart(),
              ProjectReportOutputs(
                outputsSummary: [
                  MobileOutputsSummaryModel(
                    label: 'output 1',
                    titles: ['jdfgjka', 'fdhgfjah'],
                    value: 0,
                    background: '#175CD3',
                  ),
                  MobileOutputsSummaryModel(
                    label: 'output 2',
                    titles: ['jdfgjka', 'fdhgfjah'],
                    value: 0,
                    background: '#175CD3',
                  ),
                  MobileOutputsSummaryModel(
                    label: 'output 3',
                    titles: ['jdfgjka', 'fdhgfjah'],
                    value: 0,
                    background: '#175CD3',
                  ),
                ],
              ),
              ProjectReportChallenges(challengesList: model.challenges ?? []),
              ProjectReportRisks(reportRisks: model.risks ?? []),
            ],
          ),
        ),
        16.sh,
      ],
    );
  }
}

List<ProjectsOverviewData> _generateSampleFundingData(
  // List<MobileBudgetModel> budgeList,
) {
  // return budgeList
  //     .map(
  //       (budget) => ProjectsOverviewData(
  //     name: budget.label ?? '',
  //     count: budget.amount ?? 0,
  //     hexColor: budget.background ?? '#000000',
  //     percentage: budget.percent ?? 0,
  //   ),
  // )
  //     .toList();
  return [
    ProjectsOverviewData(
      name: 'المتبقي',
      count: 100000,
      hexColor: '#175CD3',
      percentage: 10,
    ),
    ProjectsOverviewData(
      name: 'الغرامات',
      count: 600000,
      hexColor: '#020F4C',
      percentage: 60,
    ),
    ProjectsOverviewData(
      name: 'المنصرف',
      count: 400000,
      hexColor: '#DC6803',
      percentage: 40,
    ),
  ];
}
