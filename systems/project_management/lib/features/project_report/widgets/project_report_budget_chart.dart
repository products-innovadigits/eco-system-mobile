import 'package:intl/intl.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectReportBudgetChart extends StatelessWidget {
  final List<ProjectsOverviewData> data;
  final double projectBudget;

  const ProjectReportBudgetChart({
    super.key,
    required this.data,
    required this.projectBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.color.outline),
      ),
      child: Column(
        children: [
          // Custom header with icon
          _CustomHeader(),
          Divider(color: context.color.outline),
          SizedBox(height: 16.h),
          // Chart content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ChartLegend(projects: data),
                SizedBox(height: 8.h),
                _BudgetChart(projects: data, projectBudget: projectBudget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TODO: Replace with proper translation key when available
        Text(
          'تمويل المشروع', // Hardcoded: Project Financing
          style: AppTextStyles.w700.copyWith(
            fontSize: 14,
            color: context.color.primary,
            height: 20 / 14, // line-height 20px / font-size 14px
          ),
        ),
        SizedBox(width: 8.w),
        // TODO: Replace with actual file-02 icon SVG when exported
        // Using file.svg as placeholder - update path when file-02.svg is available
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Images(
            image: Assets.svgs.file.path,
            color: context.color.primary,
            width: 24.w,
            height: 24.h,
          ),
        ),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final List<ProjectsOverviewData> projects;

  const _ChartLegend({required this.projects});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      direction: Axis.horizontal,
      runSpacing: 8.h,
      spacing: 24.w,
      children: List.generate(projects.length, (i) {
        final p = projects[i];
        final color = Color(
          int.parse((p.hexColor ?? '#000000').replaceAll('#', '0xff')),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Amount text (gray)
            Flexible(
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  children: [
                    // Label (dark)
                    TextSpan(
                      text: '${p.name ?? ''} ',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: context.color.primary,
                      ),
                    ),
                    // Amount (gray)
                    TextSpan(
                      // TODO: Format currency properly with NumberFormat when data is connected
                      text: '(SAR ${_formatCurrency(p.count ?? 0)})',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: context.color.outlineVariant, // #9da4ae
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 4.w),
            // Color dot indicator
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        );
      }),
    );
  }

  // TODO: Replace with proper currency formatter when connected to real data
  String _formatCurrency(num value) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(value);
  }
}

class _BudgetChart extends StatelessWidget {
  final List<ProjectsOverviewData> projects;
  final double projectBudget;

  const _BudgetChart({required this.projects, required this.projectBudget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116.h,
      width: 232.w,
      child: Stack(
        children: [
          // Half-circle pie chart - positioned to match design
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: HalfCircleAnalyticChart(projects),
          ),
          // Center budget text - positioned at bottom center of chart
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Budget amount row (SAR + value)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // TODO: Replace with proper translation key when available
                    Text(
                      'SAR',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: context.color.outlineVariant, // #9da4ae
                      ),
                    ),
                    SizedBox(width: 4.w),
                    // TODO: Format currency properly with NumberFormat when data is connected
                    Text(
                      _formatCurrency(projectBudget),
                      style: context.textTheme.labelMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.color.secondary, // #175cd3
                        height: 1.43, // 20px line height / 14px font = 1.43
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // Budget label
                // TODO: Replace with proper translation key when available
                Text(
                  'ميزانية المشروع', // Hardcoded: Project Budget
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.color.outlineVariant, // #9da4ae
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Replace with proper currency formatter when connected to real data
  String _formatCurrency(double value) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(value);
  }
}
