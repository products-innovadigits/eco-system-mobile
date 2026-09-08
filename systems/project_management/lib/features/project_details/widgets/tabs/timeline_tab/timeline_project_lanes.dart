import 'dart:math' as math;

import 'package:project_management/core/utility/project_management_exports.dart';

/// Positions every [MilestoneLane] on the timeline canvas.
class TimelineProjectLanes extends StatelessWidget {
  final LayoutResult layout;
  final double rowH;
  final double weekWidth;
  final double totalWidth;
  final double monthsHeaderHeight;
  final double weeksHeaderHeight;
  final bool isRTL;
  final TimelineLaneMetrics metrics;
  final void Function(MilestoneModel milestone)? onMilestoneTap;
  final void Function(SubActivityModel subactivity)? onSubactivityTap;

  const TimelineProjectLanes({
    super.key,
    required this.layout,
    required this.rowH,
    required this.weekWidth,
    required this.totalWidth,
    required this.monthsHeaderHeight,
    required this.weeksHeaderHeight,
    required this.isRTL,
    this.metrics = const TimelineLaneMetrics(),
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: layout.placedMilestones.map((placed) {
        final double bandTop =
            monthsHeaderHeight + weeksHeaderHeight + placed.row * rowH;
        final double bandHeight = placed.rowSpanRows * rowH;

        final double topPx = bandTop + metrics.lanePadding;
        final double laneH = math.max(1, bandHeight - 2 * metrics.lanePadding);

        // Horizontal placement (RTL aware): `Positioned.left` is physical, so
        // the RTL canvas is mirrored explicitly.
        final double leftPx = isRTL
            ? totalWidth - placed.laneEndOffset * weekWidth
            : placed.laneStartOffset * weekWidth;

        return Positioned(
          left: leftPx,
          top: topPx,
          width: placed.laneWidth * weekWidth,
          height: laneH,
          child: MilestoneLane(
            placed: placed,
            weekWidth: weekWidth,
            isRTL: isRTL,
            metrics: metrics,
            onMilestoneTap: onMilestoneTap,
            onSubactivityTap: onSubactivityTap,
          ),
        );
      }).toList(),
    );
  }
}
