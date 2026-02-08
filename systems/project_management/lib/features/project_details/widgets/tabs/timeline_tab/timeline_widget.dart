import 'dart:math' as math;

import 'package:project_management/core/utility/project_management_exports.dart';

/// Project timeline grid with months/weeks headers and auto-placed milestone lanes.
/// - Dynamic months based on projectStart to projectEnd.
/// - 4 weeks per month (W1: 1-7, W2: 8-14, W3: 15-21, W4: 22-end).
/// - Auto-places milestones vertically using row bands.
/// - RTL support + auto height grow.
/// - Per-subactivity spacing: both band rows and vertical padding vary by sub-count.
class ProjectTimeline extends StatefulWidget {
  // ---- Layout inputs ----
  final int baseRowCount; // Initial rows count before auto-grow.
  final double monthsHeaderHeight; // Height of months header.
  final double weeksHeaderHeight; // Height of weeks row.
  final double weekWidth; // Width of a single week cell.
  final double rowHeightPx; // Explicit row height override (optional).

  // ---- Data ----
  final List<MilestoneModel>? milestonesList;
  final DateTime projectStart;
  final DateTime projectEnd;
  final TextDirection textDirection;
  final void Function(MilestoneModel milestone)? onMilestoneTap;
  final void Function(SubActivityModel subactivity)? onSubactivityTap;

  const ProjectTimeline({
    super.key,
    this.baseRowCount = 12,
    this.monthsHeaderHeight = 40,
    this.weeksHeaderHeight = 40,
    this.weekWidth = 35,
    this.rowHeightPx = 25,
    this.milestonesList,
    required this.projectStart,
    required this.projectEnd,
    this.textDirection = TextDirection.rtl,
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  @override
  State<ProjectTimeline> createState() => _ProjectTimelineState();
}

class _ProjectTimelineState extends State<ProjectTimeline> {
  List<ProjectMonth> get _months =>
      ProjectMonth.generateMonths(widget.projectStart, widget.projectEnd);

  double get _monthWidth => widget.weekWidth * 4;

  double get _totalWidth => _monthWidth * _months.length;

  @override
  Widget build(BuildContext context) {
    // Base row height (fixed unit used even when canvas grows)
    final double rowH = widget.rowHeightPx;

    // Get milestones from model
    final milestones = widget.milestonesList ?? [];

    // === Arrange milestones (auto vertical placement with row bands) ===
    final LayoutResult layout = _autoLayoutMilestones(
      milestones: milestones,
      projectStart: widget.projectStart,
      projectEnd: widget.projectEnd,
    );

    // Compute rows required considering the deepest occupied row index
    final int totalRows = math.max(
      widget.baseRowCount,
      (layout.maxRowIndex ?? -1) + 1,
    );

    // Effective canvas height (auto-grow or fixed)
    final double effectiveHeight =
        (widget.monthsHeaderHeight +
        widget.weeksHeaderHeight +
        totalRows * rowH);

    return Directionality(
      textDirection: widget.textDirection,
      child: SizedBox(
        height: effectiveHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: _totalWidth,
              height: effectiveHeight,
              // critical for Positioned children (Stack)
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
                        height: widget.monthsHeaderHeight,
                        months: _months,
                      ),
                      TimelineWeeksHeader(
                        width: _totalWidth,
                        monthWidth: _monthWidth,
                        height: widget.weeksHeaderHeight,
                        weekWidth: widget.weekWidth,
                        monthCount: _months.length,
                      ),
                      TimelineGridBody(
                        rows: totalRows,
                        width: _totalWidth,
                        monthWidth: _monthWidth,
                        weekWidth: widget.weekWidth,
                        rowHeight: rowH,
                        monthCount: _months.length,
                      ),
                    ],
                  ),

                  // ===== Milestone lanes overlay =====
                  Positioned.fill(
                    child: TimelineProjectLanes(
                      layout: layout,
                      rowH: rowH,
                      weekWidth: widget.weekWidth,
                      totalWidth: _totalWidth,
                      monthsHeaderHeight: widget.monthsHeaderHeight,
                      weeksHeaderHeight: widget.weeksHeaderHeight,
                      isRTL: widget.textDirection == TextDirection.rtl,
                      projectStart: widget.projectStart,
                      projectEnd: widget.projectEnd,
                      onMilestoneTap: widget.onMilestoneTap,
                      onSubactivityTap: widget.onSubactivityTap,
                    ),
                  ),
                ],
              ),
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
  LayoutResult _autoLayoutMilestones({
    required List<MilestoneModel> milestones,
    required DateTime projectStart,
    required DateTime projectEnd,
  }) {
    final Map<int, List<Span>> occupiedByRow = {};
    final List<PlacedMilestone> placed = [];
    int? maxRow;

    for (final milestone in milestones) {
      if (milestone.startDate == null || milestone.endDate == null) continue;

      // Convert dates to column indices
      final span = DateSpan.fromDates(
        milestone.startDate,
        milestone.endDate,
        projectStart,
        projectEnd,
      );

      if (span == null) continue;

      final int startCol = span.startCol;
      final int endCol = span.endCol;

      // Get subactivities count
      int subs = (milestone.subActivities?.length ?? 0);
      if (subs < 0) subs = 0;
      // We do not clamp here – the band height depends on the real count.

      /// Row separation heuristic (band height in rows).
      /// We make the band height depend on the number of subactivities so that
      /// the milestone bar + all subactivity chips + dashed connectors stay
      /// inside the lane without overlapping the lane below.
      ///
      /// Calculation based on actual content height:
      /// - Milestone bar: 32px
      /// - Spacing after bar: 8px
      /// - Each subactivity: 24px (chip) + 8px (spacing) = 32px
      /// - Total content: 40 + 32n pixels
      /// - Row height: 25px (default)
      /// - Bottom spacing: 1-2 rows for separation between milestones
      int rowBandForSubs(int n) {
        if (n <= 0) {
          // No subactivities: small band is enough for the milestone bar only.
          // Content: 32px bar = ~1.3 rows, add 1.5 rows for spacing = ~3 rows
          return 3;
        }

        // Constants from milestone_lane.dart
        const double milestoneBarHeight = 32.0;
        const double subactivitySpacing = 8.0;
        const double subactivityChipHeight = 24.0;
        final double rowHeight = widget.rowHeightPx;

        // Calculate actual content height needed
        final double contentHeight =
            milestoneBarHeight +
            subactivitySpacing +
            (n * (subactivityChipHeight + subactivitySpacing));

        // Convert to rows (content rows needed)
        final double contentRows = contentHeight / rowHeight;

        // Add minimal bottom spacing for separation between milestones
        // Use adaptive spacing: smaller for fewer subactivities, slightly more for many
        // This ensures consistent, minimal spacing regardless of subactivity count
        final double bottomSpacing = n <= 2 ? 0.8 : (n <= 5 ? 1.0 : 1.2);

        // Total rows needed: content + bottom spacing, rounded up
        final int totalRows = (contentRows + bottomSpacing).ceil();

        // Ensure minimum of 3 rows for visual consistency
        return math.max(3, totalRows);
      }

      final int rowStep = rowBandForSubs(subs);
      final int rowSpanRows = rowStep; // reserved band height (in rows)

      // Try to place starting from row 0
      int r = 0;
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

      placed.add(
        PlacedMilestone(
          milestone: milestone,
          row: r,
          minCol: startCol,
          maxCol: endCol,
          rowSpanRows: rowSpanRows,
          bottomRow: bottomRow,
          subCount: subs,
        ),
      );
    }

    return LayoutResult(placedMilestones: placed, maxRowIndex: maxRow);
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
