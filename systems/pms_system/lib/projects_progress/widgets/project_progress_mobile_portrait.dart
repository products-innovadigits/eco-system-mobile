import '../../shared/pms_exports.dart';

class ProjectProgressMobilePortrait extends StatelessWidget {
  final bool isPmsHome;
  final List<ProjectsOverviewData> data;
  const ProjectProgressMobilePortrait({super.key, required this.isPmsHome, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainCardWidget(
          height: 260.h,
          title: allTranslations.text(LocaleKeys.project_progress_rate),
          onViewMoreTap: () => CustomNavigator.push(
            isPmsHome ? Routes.PROJECTS : Routes.PMS_LAYOUT,
          ),
          child: _ChartDetails(
            projects: data ?? <ProjectsOverviewData>[],
          ),
        ),
        _ProgressHalfPie(projects: data ?? <ProjectsOverviewData>[]),
      ],
    );
  }
}



class _ChartDetails extends StatelessWidget {
  final List<ProjectsOverviewData> projects;

  const _ChartDetails({required this.projects});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      runSpacing: 8.w,
      spacing: 24.h,
      children: List.generate(projects.length, (i) {
        final p = projects[i];
        final color = Color(
          int.parse((p.hexColor ?? '#000000').replaceAll('#', '0xff')),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: color, size: 14),
            SizedBox(width: 4.w),
            Flexible(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: p.name,
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '(${(p.count ?? 0).toString()})',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.color.outlineVariant,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ProgressHalfPie extends StatelessWidget {
  final List<ProjectsOverviewData> projects;

  const _ProgressHalfPie({required this.projects});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        ProjectsProgressBloc,
        AppState,
        List<ProjectsOverviewData>
    >(
      selector: (state) =>
      state is Done ? (state.data ?? <ProjectsOverviewData>[]) : projects,
      builder: (context, projs) {
        final total = projs.fold<int>(0, (s, i) => s + (i.count ?? 0).toInt());
        return Positioned(
          top: 120.h,
          right: 20.w,
          child: Stack(
            children: [
              HalfCircleAnalyticChart(projs),
              Positioned(
                top: 100.h,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Text(
                        allTranslations.text(LocaleKeys.total_projects),
                        style: context.textTheme.labelSmall,
                      ),
                      Text(
                        total.toString(),
                        style: context.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.color.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
