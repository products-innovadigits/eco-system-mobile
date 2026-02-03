import 'package:project_management/core/utility/pms_exports.dart';

class ReportObjectivePercentageChartMobileLandscape extends StatelessWidget {
  final List<ReportObjectivePercentageModel> objectives;

  const ReportObjectivePercentageChartMobileLandscape({
    super.key,
    required this.objectives,
  });

  @override
  Widget build(BuildContext context) {
    // In landscape, show a compact two-column grid of the same bars.
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isWide = constraints.maxWidth > 600;
        final crossAxisCount = isWide ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3.8,
          ),
          itemCount: objectives.length,
          itemBuilder: (context, index) {
            final data = objectives[index];
            return _BarTile(data: data, index: index);
          },
        );
      },
    );
  }
}

class _BarTile extends StatelessWidget {
  final ReportObjectivePercentageModel data;
  final int index;

  const _BarTile({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final palette = const [
      Color(0xFF175CD3),
      Color(0xFFDC6803),
      Color(0xFF12B76A),
      Color(0xFF667085),
    ];
    final color = palette[index % palette.length];
    final value = (data.value ?? 0).clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.categoryName ?? '-',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 6.h),
        LinearProgressIndicator(
          value: value / 100.0,
          minHeight: 10,
          color: color,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        SizedBox(height: 6.h),
        Text('${value.toStringAsFixed(0)}%'),
      ],
    );
  }
}
