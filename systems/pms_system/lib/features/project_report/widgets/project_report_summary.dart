import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectReportSummary extends StatelessWidget {
  const ProjectReportSummary({super.key, required this.reportDetails});

  final ProjectReportDetailsModel reportDetails;

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.project_details),
      withMargin: false,
      withExpanded: false,
      leadingWidget: Images(image: Assets.svgs.list.path),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ProjectContentCard(
                  icon: Assets.svgs.user.path,
                  title: allTranslations.text(LocaleKeys.project_owner),
                  desc: reportDetails.managerName ?? '',
                  // desc: (model.endDate ?? DateTime.now()).format("d MMM yyyy"),
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: ProjectContentCard(
                  icon: Assets.svgs.user.path,
                  title: allTranslations.text(LocaleKeys.implement_department),
                  desc: reportDetails.departmentName ?? '',
                  // desc: (model.startDate ?? DateTime.now()).format("d MMM yyyy"),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ProjectContentCard(
                  icon: Assets.svgs.calendarStart.path,
                  title: allTranslations.text(LocaleKeys.start_date),
                  desc: (reportDetails.startDate ?? DateTime.now()).format(
                    "d MMM yyyy",
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: ProjectContentCard(
                  icon: Assets.svgs.calendarEnd.path,
                  title: allTranslations.text(LocaleKeys.end_date),
                  desc: (reportDetails.endDate ?? DateTime.now()).format(
                    "d MMM yyyy",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ProjectContentCard(
                  icon: Assets.svgs.sheild.path,
                  title: allTranslations.text(LocaleKeys.project_funding),
                  desc: reportDetails.approvedBudget.toString(),
                ),
              ),
              // SizedBox(width: 8.h),
              // Expanded(
              //   child: ProjectContentCard(
              //     icon: Assets.svgs.multiCard.path,
              //     title: allTranslations.text(
              //       LocaleKeys.specialized_initiative,
              //     ),
              //     desc: 'المبادرة المختصة',
              //   ),
              // ),
            ],
          ),
          // SizedBox(height: 16.h),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Expanded(
          //       child: ProjectContentCard(
          //         icon: Assets.svgs.filter.path,
          //         title: allTranslations.text(LocaleKeys.specialized_kpi),
          //         desc: 'الموشر المختص',
          //       ),
          //     ),
          //     SizedBox(width: 8.h),
          //     Expanded(
          //       child: ProjectContentCard(
          //         icon: Assets.svgs.building.path,
          //         title: allTranslations.text(LocaleKeys.specialized_section),
          //         desc: reportDetails.sectionDepartment?.name ?? '',
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
