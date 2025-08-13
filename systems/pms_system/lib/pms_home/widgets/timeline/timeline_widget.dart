import 'dart:math' as math;

import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:pms_system/pms_home/model/timeline_project_model.dart';
import 'package:pms_system/pms_home/widgets/timeline/timeline_grid_body.dart';
import 'package:pms_system/pms_home/widgets/timeline/timeline_month_header.dart';
import 'package:pms_system/pms_home/widgets/timeline/project_lane.dart';
import 'package:pms_system/pms_home/widgets/timeline/timeline_project_lanes.dart';
import 'package:pms_system/pms_home/widgets/timeline/timeline_weeks_header.dart';
import 'package:pms_system/shared/pms_exports.dart';

/// Convert 1-based (month 1..12, week 1..4) to a zero-based column index (0..47).
int _colIndexFromMonthWeek(int month, int week) {
  assert(month >= 1 && month <= 12);
  assert(week >= 1 && week <= 4);
  return (month - 1) * 4 + (week - 1);
}

/// Project timeline grid with months/weeks headers and auto-placed project lanes.
/// - 12×4 = 48 weeks (4 weeks per month).
/// - Auto-places projects vertically using row bands.
/// - RTL support + auto height grow.
/// - Per-subproject spacing: both band rows and vertical padding vary by sub-count.
class ProjectTimeline extends StatelessWidget {
  // ---- Layout inputs ----
  // final double
  //     canvasHeight; // Total initial height (used if autoGrowCanvas=false).
  final int baseRowCount; // Initial rows count before auto-grow.
  final double monthsHeaderHeight; // Height of months header.
  final double weeksHeaderHeight; // Height of weeks row.
  final double weekWidth; // Width of a single week cell.
  final double rowHeightPx; // Explicit row height override (optional).

  // ---- Data ----
  final List<ProjectItem> timelineProjects;

  const ProjectTimeline({
    super.key,
    this.baseRowCount = 12,
    this.monthsHeaderHeight = 40,
    this.weeksHeaderHeight = 40,
    this.weekWidth = 35,
    this.rowHeightPx = 25,
    this.timelineProjects = const [],
  });

  double get _monthWidth => weekWidth * 4;

  double get _totalWidth => _monthWidth * 12;

  @override
  Widget build(BuildContext context) {
    // Base row height (fixed unit used even when canvas grows)
    final double rowH = rowHeightPx;

    // === Arrange projects (auto vertical placement with row bands) ===
    final LayoutResult layout = _autoLayoutProjects(items: timelineProjects);

    // Compute rows required considering the deepest occupied row index
    final int totalRows =
        math.max(baseRowCount, (layout.maxRowIndex ?? -1) + 1);

    // Effective canvas height (auto-grow or fixed)
    final double effectiveHeight =
        (monthsHeaderHeight + weeksHeaderHeight + totalRows * rowH);

    // RTL support
    final bool isRTL = mainAppBloc.lang.value == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        height: effectiveHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _totalWidth,
            height: effectiveHeight, // critical for Positioned children (Stack)
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ===== Base table (header + weeks + grid body) =====
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TimelineMonthsHeader(
                      width: _totalWidth,
                      monthWidth: _monthWidth,
                      height: monthsHeaderHeight,
                    ),
                    TimelineWeeksHeader(
                      width: _totalWidth,
                      monthWidth: _monthWidth,
                      height: weeksHeaderHeight,
                      weekWidth: weekWidth,
                    ),
                    TimelineGridBody(
                      rows: totalRows,
                      width: _totalWidth,
                      monthWidth: _monthWidth,
                      weekWidth: weekWidth,
                      rowHeight: rowH,
                    ),
                  ],
                ),

                // ===== Project lanes overlay =====
                Positioned.fill(
                  child: TimelineProjectLanes(
                      layout: layout,
                      rowH: rowH,
                      weekWidth: weekWidth,
                      totalWidth: _totalWidth,
                      monthsHeaderHeight: monthsHeaderHeight,
                      weeksHeaderHeight: weeksHeaderHeight,
                      isRTL: isRTL),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Auto layout with fast overlap checks:
  //  - Each row keeps a sorted, MERGED list of spans [s..e] (non-overlapping).
  //  - Checking overlap becomes: binary search around insertion point.
  //  - Insertion uses merge to keep the row list compact.
  // Complexity per placement ~ O(bandRows * log K), where K is spans per row.
  // ---------------------------------------------------------------------------
  LayoutResult _autoLayoutProjects({required List<ProjectItem> items}) {
    final Map<int, List<Span>> occupiedByRow = {};
    final List<PlacedProject> placed = [];
    int? maxRow;

    for (final item in items) {
      final int a = _colIndexFromMonthWeek(item.startMonth, item.startWeek);
      final int b = _colIndexFromMonthWeek(item.endMonth, item.endWeek);
      final int startCol = math.min(a, b);
      final int endCol = math.max(a, b);

      // Clamp subprojects count to [0..2] كما طلبت
      int subs = (item.subProjects?.length ?? 0);
      if (subs < 0) subs = 0;
      if (subs > 2) subs = 2;

      /// Row separation heuristic (band height in rows):
      /// 0 subs => 3 rows, 1 sub => 4 rows (أقل من حالتين)، 2 subs => 5 rows.
      int rowBandForSubs(int n) {
        if (n == 0) return 3;
        if (n == 1) return 4; // ← أصغر من حالتين، فتقلّ المسافة
        return 5;
      }

      final int rowStep = rowBandForSubs(subs);
      final int rowSpanRows = rowStep; // reserved band height (in rows)

      // Try to place starting from preferredRow (if provided), else 0
      int r = item.preferredRow ?? 0;
      while (_bandOverlapsFast(
        occupied: occupiedByRow,
        topRow: r,
        bandRows: rowSpanRows,
        s: startCol,
        e: endCol,
      )) {
        r += rowStep; // shift down by step until we find a free band
      }

      // Mark rows in the band as occupied by [startCol..endCol] (merged insert)
      for (int rr = r; rr < r + rowSpanRows; rr++) {
        final list = (occupiedByRow[rr] ??= <Span>[]);
        _addMergedSpan(list, Span(startCol, endCol));
      }

      final int bottomRow = r + rowSpanRows - 1;
      if (maxRow == null || bottomRow > maxRow) maxRow = bottomRow;

      placed.add(PlacedProject(
        item: item,
        row: r,
        minCol: startCol,
        maxCol: endCol,
        rowSpanRows: rowSpanRows,
        bottomRow: bottomRow,
        subCount: subs, // ← نحتفظ بالعدد لاستخدامه في اختيار الـ padding
      ));
    }

    return LayoutResult(placed: placed, maxRowIndex: maxRow);
  }

  /// Fast overlap check across a contiguous band of rows using merged, sorted spans.
  bool _bandOverlapsFast({
    required Map<int, List<Span>> occupied,
    required int topRow,
    required int bandRows,
    required int s,
    required int e,
  }) {
    for (int rr = topRow; rr < topRow + bandRows; rr++) {
      final spans = occupied[rr];
      if (_overlapsMerged(spans, s, e)) return true;
    }
    return false;
  }

  /// Check if [s..e] overlaps any span in a merged, sorted list.
  bool _overlapsMerged(List<Span>? spans, int s, int e) {
    if (spans == null || spans.isEmpty) return false;

    // Find first index with start >= s using lowerBound
    final int idx = _lowerBound(spans, s);

    // Candidate overlap could be the one just before idx (start < s)
    if (idx > 0) {
      final prev = spans[idx - 1];
      if (!(e < prev.s || s > prev.e)) return true;
    }

    // Also check the element at idx (start >= s)
    if (idx < spans.length) {
      final cur = spans[idx];
      if (!(e < cur.s || s > cur.e)) return true;
    }

    return false;
  }

  /// Insert [span] into merged, sorted spans list in O(log n + merges).
  void _addMergedSpan(List<Span> spans, Span span) {
    if (spans.isEmpty) {
      spans.add(span);
      return;
    }

    // Position by start using lowerBound
    int i = _lowerBound(spans, span.s);

    // Merge with previous if overlaps/touches
    int start = span.s;
    int end = span.e;

    if (i > 0 && spans[i - 1].e >= start - 1) {
      i -= 1;
      start = math.min(start, spans[i].s);
      end = math.max(end, spans[i].e);
      spans.removeAt(i);
    }

    // Merge forward with any that overlap/touch
    while (i < spans.length && spans[i].s <= end + 1) {
      start = math.min(start, spans[i].s);
      end = math.max(end, spans[i].e);
      spans.removeAt(i);
    }

    // Insert merged
    spans.insert(i, Span(start, end));
  }

  /// Binary search: first index whose start >= x
  int _lowerBound(List<Span> spans, int x) {
    int lo = 0, hi = spans.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (spans[mid].s < x) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}
