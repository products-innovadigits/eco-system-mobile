import 'package:pms_package/shared/pms_exports.dart';

class ProjectDetailsDescription extends StatelessWidget {
  const ProjectDetailsDescription({super.key, required this.model});

  final ProjectDetailsModel model;

  @override
  Widget build(BuildContext context) {
    final projectStages = model.projectLifeCycle?.projectStages ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(model.description ?? "",
            textAlign: TextAlign.start, style: context.textTheme.bodySmall),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.calendar.path,
                title: allTranslations.text("start_date"),
                desc: (model.startDate ?? DateTime.now()).format("d MMM yyyy"),
              ),
            ),
            SizedBox(width: 8.h),
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.calendarTick.path,
                title: allTranslations.text("end_date"),
                desc: (model.endDate ?? DateTime.now()).format("d MMM yyyy"),
              ),
            )
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.securityUser.path,
                title: allTranslations.text("the_owning_entity"),
                desc: model.sectionDepartment?.name ?? "",
              ),
            ),
            SizedBox(width: 8.h),
            Expanded(
              child: ProjectContentCard(
                  icon: Assets.svgs.projectLifeCycle.path,
                  title: allTranslations.text("project_life_cycle"),
                  desc: projectStages.isNotEmpty
                      ? (projectStages[0].title ?? '')
                      : ''
                  // model.projectLifeCycle?.projectStages
                  //         ?.firstWhere((e) => e.lifeCycleId == model.lifeCycleId)
                  //         .title ??
                  //     "",
                  ),
            )
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.filter.path,
                title: allTranslations.text("project_category"),
                desc: model.title ?? "",
              ),
            ),
            SizedBox(width: 8.h),
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.user.path,
                title: allTranslations.text("project_manager"),
                desc: model.managerName ?? "",
              ),
            )
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.people.path,
                title: allTranslations.text("project_team"),
                desc: "${model.teamIds?.join(", ")}",
              ),
            ),
            SizedBox(width: 8.h),
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.warning.path,
                title: allTranslations.text("risk_level"),
                desc: "${model.riskLevelId ?? 0}",
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
                icon: Assets.svgs.outlineMoneys.path,
                title: allTranslations.text("budget"),
                desc: "${model.budget ?? 0}",
              ),
            ),
            SizedBox(width: 8.h),
            Expanded(
              child: ProjectContentCard(
                icon: Assets.svgs.task.path,
                title: allTranslations.text("outputs_number"),
                desc: "${model.outputCount ?? 0}",
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ProjectContentCard(
          icon: Assets.svgs.building.path,
          title: allTranslations.text("entity_name"),
          desc: model.implementorDepartmentName ?? "",
        ),
      ],
    );
  }
}
