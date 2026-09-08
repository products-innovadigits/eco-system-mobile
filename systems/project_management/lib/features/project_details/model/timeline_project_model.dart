import 'package:project_management/core/utility/project_management_exports.dart';

/// A horizontal range on the timeline axis, expressed in column units
/// (see [TimelineWindow]). Used by the auto-layout to detect collisions.
class Span {
  final double s, e;

  const Span(this.s, this.e);
}

/// A sub-activity resolved to its final position on the timeline axis.
class PlacedSubActivity {
  final SubActivityModel subActivity;

  /// Range on the timeline axis, in column units.
  final double startOffset, endOffset;

  const PlacedSubActivity({
    required this.subActivity,
    required this.startOffset,
    required this.endOffset,
  });
}

/// A milestone resolved to its final position on the timeline.
///
/// [laneStartOffset] / [laneEndOffset] bound the whole lane: the union of the
/// milestone bar and every sub-activity, so that no child is ever painted
/// outside its parent (children outside the lane's box are not hit-testable and
/// would silently lose their tap / tooltip).
class PlacedMilestone {
  final MilestoneModel milestone;

  final int row; // top row of the reserved band
  final int rowSpanRows; // band height in rows
  final int bottomRow; // inclusive

  /// Lane bounds on the timeline axis, in column units.
  final double laneStartOffset, laneEndOffset;

  /// The milestone bar itself, in column units.
  final double barStartOffset, barEndOffset;

  final List<PlacedSubActivity> subActivities;

  const PlacedMilestone({
    required this.milestone,
    required this.row,
    required this.rowSpanRows,
    required this.bottomRow,
    required this.laneStartOffset,
    required this.laneEndOffset,
    required this.barStartOffset,
    required this.barEndOffset,
    required this.subActivities,
  });

  int get subCount => subActivities.length;

  double get laneWidth => laneEndOffset - laneStartOffset;
}

class LayoutResult {
  final List<PlacedMilestone> placedMilestones;
  final int? maxRowIndex; // deepest occupied row

  const LayoutResult({
    required this.placedMilestones,
    required this.maxRowIndex,
  });
}
