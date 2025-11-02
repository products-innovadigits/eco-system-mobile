import 'package:flutter/material.dart';

import '../model/report_objective_percentage_model.dart';

class ReportChartCategoriesSection extends StatelessWidget {
  final List<ReportObjectivePercentageModel> objectives;
  final List<Color>? colors;

  const ReportChartCategoriesSection({
    super.key,
    required this.objectives,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final palette =
        colors ??
        const [
          Color(0xFF175CD3),
          Color(0xFFDC6803),
          Color(0xFF12B76A),
          Color(0xFF667085),
          Color(0xFF7A5AF8),
        ];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: List.generate(objectives.length, (index) {
        final item = objectives[index];
        final color = palette[index % palette.length];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              item.categoryName ?? '-',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }),
    );
  }
}
