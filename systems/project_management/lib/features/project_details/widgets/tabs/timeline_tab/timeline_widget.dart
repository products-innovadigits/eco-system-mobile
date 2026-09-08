import 'dart:math' as math;

import 'package:project_management/core/utility/project_management_exports.dart';

/// Project timeline grid with months/weeks headers and auto-placed milestone lanes.
/// - Dynamic months based on the resolved [TimelineWindow].
/// - 4 week columns per month (W1: 1-7, W2: 8-14, W3: 15-21, W4: 22-end);
///   items snap to whole week cells.
/// - Auto-places milestones vertically using row bands.
/// - RTL support + auto height grow.
class ProjectTimeline extends StatefulWidget {
  // ---- Layout inputs ----
  final int baseRowCount; // Initial rows count before auto-grow.
  final double monthsHeaderHeight; // Height of months header.
  final double weeksHeaderHeight; // Height of weeks row.
  final double weekWidth; // Width of a single week cell.
  final double rowHeightPx; // Explicit row height override (optional).

  /// Smallest width a bar / chip may take, so that a one-day item stays
  /// readable and tappable instead of collapsing to a few pixels.
  final double minItemWidth;

  // ---- Data ----
  final List<MilestoneModel>? milestonesList;

  /// Project bounds. Only hints: the real window is widened to fit the data.
  final DateTime? projectStart;
  final DateTime? projectEnd;

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
    this.minItemWidth = 32,
    this.milestonesList,
    this.projectStart,
    this.projectEnd,
    this.textDirection = TextDirection.rtl,
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  @override
  State<ProjectTimeline> createState() => _ProjectTimelineState();
}

class _ProjectTimelineState extends State<ProjectTimeline> {
  /// Horizontal breathing room kept between two lanes sharing the same rows,
  /// in column units. Zero lets two lanes sit edge to edge in one band, which
  /// is what week snapping needs to stay compact; raise it to force a visible
  /// gap at the cost of extra rows.
  static const double _laneGapCols = 0;

  late TimelineWindow _window;
  late List<ProjectMonth> _months;
  late LayoutResult _layout;

  double get _monthWidth => widget.weekWidth * TimelineWindow.columnsPerMonth;

  double get _totalWidth => _monthWidth * _months.length;

  /// Right edge of the axis, in column units.
  double get _axisEnd => _months.length * TimelineWindow.columnsPerMonth;

  @override
  void initState() {
    super.initState();
    _resolveLayout();
  }

  @override
  void didUpdateWidget(covariant ProjectTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Placement is pure w.r.t. these inputs, so it only has to run when one of
    // them actually changes - not on every rebuild.
    if (!identical(oldWidget.milestonesList, widget.milestonesList) ||
        oldWidget.projectStart != widget.projectStart ||
        oldWidget.projectEnd != widget.projectEnd ||
        oldWidget.weekWidth != widget.weekWidth ||
        oldWidget.rowHeightPx != widget.rowHeightPx ||
        oldWidget.minItemWidth != widget.minItemWidth) {
      _resolveLayout();
    }
  }

  void _resolveLayout() {
    final List<MilestoneModel> milestones = widget.milestonesList ?? const [];

    _window = TimelineWindow.resolve(
      projectStart: widget.projectStart,
      projectEnd: widget.projectEnd,
      milestones: milestones,
    );
    _months = ProjectMonth.generateMonths(_window.start, _window.end);
    _layout = _autoLayoutMilestones(milestones);
  }

  @override
  Widget build(BuildContext context) {
    final double rowH = widget.rowHeightPx;

    // Compute rows required considering the deepest occupied row index
    final int totalRows = math.max(
      widget.baseRowCount,
      (_layout.maxRowIndex ?? -1) + 1,
    );

    final double effectiveHeight =
        widget.monthsHeaderHeight + widget.weeksHeaderHeight + totalRows * rowH;

    return Directionality(
      textDirection: widget.textDirection,
      child: SizedBox(
        height: effectiveHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
                    layout: _layout,
                    rowH: rowH,
                    weekWidth: widget.weekWidth,
                    totalWidth: _totalWidth,
                    monthsHeaderHeight: widget.monthsHeaderHeight,
                    weeksHeaderHeight: widget.weeksHeaderHeight,
                    isRTL: widget.textDirection == TextDirection.rtl,
                    onMilestoneTap: widget.onMilestoneTap,
                    onSubactivityTap: widget.onSubactivityTap,
                  ),
                ),
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
  // ---------------------------------------------------------------------------
  LayoutResult _autoLayoutMilestones(List<MilestoneModel> milestones) {
    final Map<int, List<Span>> occupiedByRow = {};
    final List<PlacedMilestone> placed = [];
    int? maxRow;

    // Place the earliest milestones first so the bands read top-to-bottom in
    // chronological order and pack tightly.
    final List<MilestoneModel> ordered = List.of(milestones)
      ..sort((a, b) => _compareDates(a.startDate, b.startDate));

    for (final milestone in ordered) {
      final DateSpan? barSpan = _renderSpan(
        _window.spanOf(milestone.startDate, milestone.endDate),
      );
      if (barSpan == null) continue;

      // Sub-activities, sorted and resolved once per milestone.
      final List<PlacedSubActivity> subActivities = [];
      double laneStart = barSpan.start;
      double laneEnd = barSpan.end;

      final List<SubActivityModel> subs = List.of(
        milestone.subActivities ?? const <SubActivityModel>[],
      )..sort((a, b) => _compareDates(a.startDate, b.startDate));

      for (final sub in subs) {
        final DateSpan? subSpan = _renderSpan(
          _window.spanOf(sub.startDate, sub.endDate),
        );
        if (subSpan == null) continue;

        subActivities.add(
          PlacedSubActivity(
            subActivity: sub,
            startOffset: subSpan.start,
            endOffset: subSpan.end,
          ),
        );
        // The lane must contain its children: anything painted outside the
        // lane's box would not receive taps.
        laneStart = math.min(laneStart, subSpan.start);
        laneEnd = math.max(laneEnd, subSpan.end);
      }

      final int rowSpanRows = _rowBandFor(subActivities.length);

      // Find the first row band that is free for this horizontal range.
      int r = 0;
      while (_bandOverlaps(
        occupied: occupiedByRow,
        topRow: r,
        bandRows: rowSpanRows,
        s: laneStart,
        e: laneEnd,
      )) {
        r++;
      }

      // Mark the band as occupied, padded by the lane gap so neighbouring
      // lanes never touch.
      for (int rr = r; rr < r + rowSpanRows; rr++) {
        final list = (occupiedByRow[rr] ??= <Span>[]);
        _addMergedSpan(
          list,
          Span(laneStart - _laneGapCols, laneEnd + _laneGapCols),
        );
      }

      final int bottomRow = r + rowSpanRows - 1;
      if (maxRow == null || bottomRow > maxRow) maxRow = bottomRow;

      placed.add(
        PlacedMilestone(
          milestone: milestone,
          row: r,
          rowSpanRows: rowSpanRows,
          bottomRow: bottomRow,
          laneStartOffset: laneStart,
          laneEndOffset: laneEnd,
          barStartOffset: barSpan.start,
          barEndOffset: barSpan.end,
          subActivities: subActivities,
        ),
      );
    }

    return LayoutResult(placedMilestones: placed, maxRowIndex: maxRow);
  }

  static int _compareDates(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  /// Widens a span that would render narrower than [ProjectTimeline.minItemWidth],
  /// keeping it inside the axis.
  DateSpan? _renderSpan(DateSpan? span) {
    if (span == null) return null;

    final double minCols = widget.minItemWidth / widget.weekWidth;
    if (span.width >= minCols) return span;

    double start = span.start;
    double end = start + minCols;
    if (end > _axisEnd) {
      end = _axisEnd;
      start = math.max(0, end - minCols);
    }
    return DateSpan(start, end);
  }

  /// Band height in rows.
  ///
  /// The band has to hold everything [MilestoneLane] paints — its bar, its
  /// chips and the spacing between them — which is why the geometry lives on
  /// the lane and is read from here instead of being duplicated.
  int _rowBandFor(int subCount) {
    final double contentHeight =
        MilestoneLane.contentHeightFor(subCount) +
        MilestoneLane.lanePadding * 2;

    // Minimal separation between two stacked milestones.
    final double bottomSpacing = subCount <= 2
        ? 0.8
        : (subCount <= 5 ? 1.0 : 1.2);
    final int totalRows = (contentHeight / widget.rowHeightPx + bottomSpacing)
        .ceil();

    // Keep a floor for visual consistency.
    return math.max(3, totalRows);
  }

  /// Fast overlap check across a contiguous band of rows using merged, sorted spans.
  bool _bandOverlaps({
    required Map<int, List<Span>> occupied,
    required int topRow,
    required int bandRows,
    required double s,
    required double e,
  }) {
    for (int rr = topRow; rr < topRow + bandRows; rr++) {
      if (_overlapsMerged(occupied[rr], s, e)) return true;
    }
    return false;
  }

  /// Check if [s..e] overlaps any span in a merged, sorted list.
  bool _overlapsMerged(List<Span>? spans, double s, double e) {
    if (spans == null || spans.isEmpty) return false;

    // Find first index with start >= s using lowerBound
    final int idx = _lowerBound(spans, s);

    // Candidate overlap could be the one just before idx (start < s)
    if (idx > 0) {
      final prev = spans[idx - 1];
      if (!(e <= prev.s || s >= prev.e)) return true;
    }

    // Also check the element at idx (start >= s)
    if (idx < spans.length) {
      final cur = spans[idx];
      if (!(e <= cur.s || s >= cur.e)) return true;
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

    double start = span.s;
    double end = span.e;

    // Merge with previous if it overlaps
    if (i > 0 && spans[i - 1].e >= start) {
      i -= 1;
      start = math.min(start, spans[i].s);
      end = math.max(end, spans[i].e);
      spans.removeAt(i);
    }

    // Merge forward with any that overlap
    while (i < spans.length && spans[i].s <= end) {
      start = math.min(start, spans[i].s);
      end = math.max(end, spans[i].e);
      spans.removeAt(i);
    }

    // Insert merged
    spans.insert(i, Span(start, end));
  }

  /// Binary search: first index whose start >= x
  int _lowerBound(List<Span> spans, double x) {
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
