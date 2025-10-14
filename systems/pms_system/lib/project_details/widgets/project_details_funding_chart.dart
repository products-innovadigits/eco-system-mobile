import '../../shared/pms_exports.dart';

class ProjectDetailsFundingChart extends StatelessWidget {
  final List<ProjectsOverviewData> data;
  final double projectBudget;

  const ProjectDetailsFundingChart({super.key, required this.data, required this.projectBudget});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainCardWidget(
          height: 300.h,
          title: allTranslations.text(LocaleKeys.project_financing),
          child: _ChartDetails(projects: data),
        ),
        _ProgressHalfPie(projects: data , projectBudget: projectBudget),
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
      alignment: WrapAlignment.center,
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
              '(${(p.count ?? 0).toString()} SAR)',
              style: context.textTheme.bodySmall?.copyWith(
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
  final double projectBudget;

  const _ProgressHalfPie({required this.projects, required this.projectBudget});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 140.h,
      right: 20.w,
      child: Stack(
        children: [
          HalfCircleAnalyticChart(projects),
          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Text(
                    projectBudget.toString(),
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.color.secondary,
                    ),
                  ),
                  Text(
                    allTranslations.text(LocaleKeys.project_funding),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.color.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
