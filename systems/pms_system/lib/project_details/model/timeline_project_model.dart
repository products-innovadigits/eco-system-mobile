import 'package:pms_system/project_details/model/project_timeline_model.dart';

class ProjectItem {
  final int startMonth, startWeek;
  final int endMonth, endWeek;
  final int? preferredRow;
  final String? name;
  final List<ProjectItem>? subProjects ;

  const ProjectItem({
    required this.startMonth,
    required this.startWeek,
    required this.endMonth,
    required this.endWeek,
    this.subProjects,
    this.preferredRow,
    this.name,
  })  : assert(startMonth >= 1 && startMonth <= 12),
        assert(endMonth >= 1 && endMonth <= 12),
        assert(startWeek >= 1 && startWeek <= 4),
        assert(endWeek >= 1 && endWeek <= 4);
}

class Span {
  final int s, e;

  Span(this.s, this.e);
}

class PlacedProject {
  final ProjectItem item;
  final int row; // top row of the reserved band
  final int minCol, maxCol;
  final int rowSpanRows; // band height in rows
  final int bottomRow; // inclusive
  final int subCount; // 0..2 (clamped)

  PlacedProject({
    required this.item,
    required this.row,
    required this.minCol,
    required this.maxCol,
    required this.rowSpanRows,
    required this.bottomRow,
    required this.subCount,
  });
}

class PlacedMilestone {
  final MilestoneModel milestone;
  final int row; // top row of the reserved band
  final int minCol, maxCol;
  final int rowSpanRows; // band height in rows
  final int bottomRow; // inclusive
  final int subCount; // total subactivities count

  PlacedMilestone({
    required this.milestone,
    required this.row,
    required this.minCol,
    required this.maxCol,
    required this.rowSpanRows,
    required this.bottomRow,
    required this.subCount,
  });
}

class LayoutResult {
  final List<PlacedProject>? placed;
  final List<PlacedMilestone>? placedMilestones;
  final int? maxRowIndex; // deepest occupied row
  LayoutResult({
    this.placed,
    this.placedMilestones,
    required this.maxRowIndex,
  });
}
