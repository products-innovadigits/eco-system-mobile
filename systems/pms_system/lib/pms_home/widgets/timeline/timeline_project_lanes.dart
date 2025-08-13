import 'dart:math' as math;

import 'package:pms_system/pms_home/model/timeline_project_model.dart';
import 'package:pms_system/pms_home/widgets/timeline/project_lane.dart';

import '../../../shared/pms_exports.dart';

class TimelineProjectLanes extends StatelessWidget {
  final LayoutResult layout;
  final double rowH;
  final double weekWidth;
  final double totalWidth;
  final double monthsHeaderHeight;
  final double weeksHeaderHeight;
  final bool isRTL;

  const TimelineProjectLanes(
      {super.key,
      required this.layout,
      required this.rowH,
      required this.weekWidth,
      required this.totalWidth,
      required this.monthsHeaderHeight,
      required this.weeksHeaderHeight,
      required this.isRTL});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ...layout.placed.map((p) {
          final double bandTop =
              monthsHeaderHeight + weeksHeaderHeight + p.row * rowH;
          final double bandHeight = p.rowSpanRows * rowH;

          // اختر padding حسب عدد الـ subprojects (0..2)
          // final int subs = p.subCount;
          final double perLanePadding = 6;
          // subs == 0 ? 6 : (subs == 1 ? 6 : 6);

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
        })
      ],
    );
  }
}
