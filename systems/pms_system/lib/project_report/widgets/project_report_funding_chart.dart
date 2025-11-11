import 'package:syncfusion_flutter_charts/charts.dart';

import '../../shared/pms_exports.dart';

class ProjectReportFundingChart extends StatelessWidget {
  final List<ProjectsOverviewData> data;
  final double projectBudget;

  const ProjectReportFundingChart({
    super.key,
    required this.data,
    required this.projectBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainCardWidget(
          height: 270,
          title: allTranslations.text(LocaleKeys.project_financing),
          child: _ChartDetails(projects: data),
        ),
        _ProgressHalfPie(projects: data, projectBudget: projectBudget),
      ],
    );
  }
}

class _ChartDetails extends StatelessWidget {
  final List<ProjectsOverviewData> projects;

  const _ChartDetails({required this.projects});

  Color _parseHex(String? hex) {
    final h = (hex ?? '#000000').replaceAll('#', '');
    final value =
        int.tryParse(h.length == 6 ? 'ff$h' : h, radix: 16) ?? 0xff000000;
    return Color(value);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      runSpacing: 8.w,
      spacing: 24.h,
      children: projects.map((p) {
        final color = _parseHex(p.hexColor);
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
      }).toList(),
    );
  }
}

class _ProgressHalfPie extends StatelessWidget {
  final List<ProjectsOverviewData> projects;
  final double projectBudget;

  const _ProgressHalfPie({required this.projects, required this.projectBudget});

  @override
  Widget build(BuildContext context) {
    // Base positioning constants
    const topOffset = 120.0;
    const rightOffset = 20.0;

    // Display up to three donut charts, compute radii based on index.
    final donutItems = projects.take(3).toList();

    return Positioned(
      top: topOffset,
      right: rightOffset.w,
      child: SizedBox(
        height: 280,
        width: 280,
        child: Stack(
          children: [
            // build donuts from back to front
            for (var i = 0; i < donutItems.length; i++)
              _HalfCircleAnalyticChart(
                project: donutItems[i],
                radiusPercent: 60 + i * 13,
                innerRadiusPercent: 86 + i * (i == 2 ? 2 : 3),
              ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Text(
                      projectBudget.toString(),
                      style: context.textTheme.labelMedium?.copyWith(
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
      ),
    );
  }
}

class _HalfCircleAnalyticChart extends StatelessWidget {
  const _HalfCircleAnalyticChart({
    super.key,
    required this.project,
    required this.radiusPercent,
    required this.innerRadiusPercent,
  });

  final ProjectsOverviewData project;
  final double radiusPercent;
  final double innerRadiusPercent;

  Color _parseHex(String? hex) {
    final h = (hex ?? '#000000').replaceAll('#', '');
    final value =
        int.tryParse(h.length == 6 ? 'ff$h' : h, radix: 16) ?? 0xff000000;
    return Color(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = (project.percentage ?? 0) <= 0.0;
    final color = isDisabled
        ? const Color(0xFFEFEFF5)
        : _parseHex(project.hexColor);

    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 280,
        width: 280,
        child: SfCircularChart(
          series: [
            DoughnutSeries<ProjectsOverviewData, String>(
              dataSource: [project],
              xValueMapper: (d, _) => d.name,
              yValueMapper: (d, _) => isDisabled ? 1 : (d.count ?? 0),
              pointColorMapper: (_, __) => color,
              startAngle: 270,
              endAngle: 90,
              innerRadius: '${innerRadiusPercent.toStringAsFixed(0)}%',
              radius: '${radiusPercent.toStringAsFixed(0)}%',
              emptyPointSettings: const EmptyPointSettings(
                mode: EmptyPointMode.zero,
              ),
              animationDuration: isDisabled ? 0 : 300,
            ),
          ],
        ),
      ),
    );
  }
}
