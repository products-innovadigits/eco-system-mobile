import 'package:project_management/core/utility/project_management_exports.dart';

/// The projects progress card: a legend of the project statuses and a half
/// pie of their counts. Landscape gets a taller card and a bigger chart.
class ProjectProgressCard extends StatelessWidget {
  final bool isProjectManagementHome;
  final List<ProjectsOverviewData> data;
  final bool isLandscape;

  const ProjectProgressCard({
    super.key,
    required this.isProjectManagementHome,
    required this.data,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainCardWidget(
          height: (isLandscape ? 520 : 260).h,
          title: allTranslations.text(LocaleKeys.project_progress_rate),
          moreBtnTxt: isProjectManagementHome
              ? allTranslations.text(LocaleKeys.view_projects)
              : null,
          onViewMoreTap: () {
            if (!isProjectManagementHome) {
              UserBloc.currentActiveSystem = ActiveSystemEnum.projectManagement;
            }
            isProjectManagementHome
                ? CustomNavigator.push(Routes.PROJECTS)
                : CustomNavigator.push(
                    Routes.SYSTEM_SWITCHER,
                    arguments: ActiveSystemEnum.projectManagement,
                  );
          },
          child: _ChartDetails(projects: data, isLandscape: isLandscape),
        ),
        _ProgressHalfPie(projects: data, isLandscape: isLandscape),
      ],
    );
  }
}

class _ChartDetails extends StatelessWidget {
  final List<ProjectsOverviewData> projects;
  final bool isLandscape;

  const _ChartDetails({required this.projects, required this.isLandscape});

  /// The API's `#RRGGBB`; black when missing or malformed.
  static Color _color(String? hex) {
    final rgb = int.tryParse((hex ?? '').replaceFirst('#', ''), radix: 16);
    return Color(0xff000000 | (rgb ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: isLandscape ? WrapAlignment.start : WrapAlignment.center,
      direction: Axis.horizontal,
      runSpacing: 8.w,
      spacing: 24.h,
      children: List.generate(projects.length, (i) {
        final p = projects[i];
        final color = _color(p.hexColor);
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
  final bool isLandscape;

  const _ProgressHalfPie({required this.projects, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    final total = projects.fold<int>(0, (s, i) => s + (i.count ?? 0).toInt());
    return Positioned(
      top: isLandscape ? 100 : 120.h,
      left: isLandscape ? 0 : null,
      right: isLandscape ? 0 : 20.w,
      child: Stack(
        children: [
          isLandscape
              ? HalfCircleAnalyticChart(projects, height: 300)
              : HalfCircleAnalyticChart(projects),
          Positioned(
            top: (isLandscape ? 200 : 90).h,
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
  }
}
