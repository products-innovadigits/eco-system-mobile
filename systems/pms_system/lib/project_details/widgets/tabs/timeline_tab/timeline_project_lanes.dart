import 'dart:math' as math;

import 'package:pms_system/project_details/model/project_timeline_model.dart';
import 'package:pms_system/project_details/model/timeline_project_model.dart';
import 'package:pms_system/project_details/widgets/tabs/timeline_tab/milestone_lane.dart';
import 'package:pms_system/project_details/widgets/tabs/timeline_tab/project_lane.dart';

import '../../../../shared/pms_exports.dart';

class TimelineProjectLanes extends StatelessWidget {
  final LayoutResult layout;
  final double rowH;
  final double weekWidth;
  final double totalWidth;
  final double monthsHeaderHeight;
  final double weeksHeaderHeight;
  final bool isRTL;
  final DateTime projectStart;
  final DateTime projectEnd;
  final Set<int> expandedMilestoneIds;
  final void Function(int milestoneId) onToggleExpansion;
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
    required this.projectStart,
    required this.projectEnd,
    required this.expandedMilestoneIds,
    required this.onToggleExpansion,
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Render old ProjectItem lanes (for backward compatibility)
        if (layout.placed != null)
          ...layout.placed!.map((p) {
            final double bandTop =
                monthsHeaderHeight + weeksHeaderHeight + p.row * rowH;
            final double bandHeight = p.rowSpanRows * rowH;

            final double perLanePadding = 6;
            final double topPx = bandTop + perLanePadding;
            final double laneH = math.max(1, bandHeight - 2 * perLanePadding);

            // Horizontal placement (RTL aware)
            final double leftPx = isRTL
                ? totalWidth - (p.maxCol + 1) * weekWidth
                : p.minCol * weekWidth;

            final double laneWidth = (p.maxCol - p.minCol + 1) * weekWidth;

            return Positioned(
              left: leftPx,
              top: topPx,
              width: laneWidth,
              height: laneH,
              child: ProjectLane(
                name: p.item.name,
                items: p.item.subProjects ?? [],
              ),
            );
          }),

        // Render milestone lanes
        if (layout.placedMilestones != null)
          ...layout.placedMilestones!.map((p) {
            final double bandTop =
                monthsHeaderHeight + weeksHeaderHeight + p.row * rowH;
            final double bandHeight = p.rowSpanRows * rowH;

            final double perLanePadding = 6;
            final double topPx = bandTop + perLanePadding;
            final double laneH = math.max(1, bandHeight - 2 * perLanePadding);

            // Horizontal placement (RTL aware)
            final double leftPx = isRTL
                ? totalWidth - (p.maxCol + 1) * weekWidth
                : p.minCol * weekWidth;

            final double laneWidth = (p.maxCol - p.minCol + 1) * weekWidth;

            final isExpanded = expandedMilestoneIds.contains(p.milestone.id);

            return Positioned(
              left: leftPx,
              top: topPx,
              width: laneWidth,
              height: laneH,
              child: MilestoneLane(
                milestone: p.milestone,
                weekWidth: weekWidth,
                projectStart: projectStart,
                projectEnd: projectEnd,
                isExpanded: isExpanded,
                onToggleExpansion: () => onToggleExpansion(p.milestone.id ?? -1),
                onMilestoneTap: onMilestoneTap,
                onSubactivityTap: onSubactivityTap,
              ),
            );
          }),
      ],
    );
  }
}
