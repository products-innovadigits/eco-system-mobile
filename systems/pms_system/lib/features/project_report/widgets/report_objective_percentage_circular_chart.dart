import 'package:flutter/material.dart';

import '../model/report_objective_percentage_model.dart';

class ReportObjectivePercentageCircularChart extends StatelessWidget {
  final List<ReportObjectivePercentageModel> objectives;
  final List<Color> colors;
  final double size;
  final double strokeWidth;

  const ReportObjectivePercentageCircularChart({
    super.key,
    required this.objectives,
    required this.colors,
    this.size = 200,
    this.strokeWidth = 14,
  });

  @override
  Widget build(BuildContext context) {
    final total = objectives.fold<double>(0, (p, e) => p + (e.value ?? 0));
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(
          objectives: objectives,
          colors: colors,
          total: total == 0 ? 1 : total,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<ReportObjectivePercentageModel> objectives;
  final List<Color> colors;
  final double total;
  final double strokeWidth;

  _DonutPainter({
    required this.objectives,
    required this.colors,
    required this.total,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background ring
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw segments
    double startAngle = -90 * 3.1415926535 / 180; // start at top
    for (int i = 0; i < objectives.length; i++) {
      final value = (objectives[i].value ?? 0).clamp(0, double.infinity);
      if (value <= 0) continue;
      final sweepAngle = (value / total) * 2 * 3.1415926535;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.objectives != objectives ||
        oldDelegate.colors != colors ||
        oldDelegate.total != total ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

