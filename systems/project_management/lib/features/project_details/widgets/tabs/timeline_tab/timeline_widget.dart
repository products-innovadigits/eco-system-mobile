import 'dart:math' as math;

import 'package:project_management/core/utility/project_management_exports.dart';

/// Project timeline grid with months/weeks headers and auto-placed milestone lanes.
/// - Dynamic months based on the resolved [TimelineWindow].
/// - 4 week columns per month (W1: 1-7, W2: 8-14, W3: 15-21, W4: 22-end);
///   items snap to whole week cells.
/// - Columns stretch to fill the available width and fall back to scrolling
///   once the project no longer fits at [ProjectTimeline.minWeekWidth].
/// - Auto-places milestones vertically using row bands.
/// - RTL support + auto height grow.
class ProjectTimeline extends StatefulWidget {
  // ---- Layout inputs ----
  final int baseRowCount; // Initial rows count before auto-grow.
  final double monthsHeaderHeight; // Height of months header.
  final double weeksHeaderHeight; // Height of weeks row.
  final double rowHeightPx; // Explicit row height override (optional).

  /// Narrowest a week column may get. Columns grow beyond it to fill the
  /// viewport, so a short project spreads across the screen instead of
  /// leaving it half empty.
  final double minWeekWidth;

  /// Smallest width a bar / chip may take, so that a one-day item stays
  /// readable and tappable instead of collapsing to a few pixels.
  final double minItemWidth;

  // ---- Data ----
  final List<MilestoneModel>? milestonesList;

  /// Project bounds. Only hints: the real window is widened to fit the data.
  final DateTime? projectStart;
  final DateTime? projectEnd;

  /// Lane geometry. Scale it up to make bars, chips and labels bigger — for
  /// instance on the full-screen canvas.
  final TimelineLaneMetrics laneMetrics;

  final TextDirection textDirection;
  final void Function(MilestoneModel milestone)? onMilestoneTap;
  final void Function(SubActivityModel subactivity)? onSubactivityTap;

  const ProjectTimeline({
    super.key,
    this.baseRowCount = 12,
    this.monthsHeaderHeight = 40,
    this.weeksHeaderHeight = 40,
    this.rowHeightPx = 25,
    this.minWeekWidth = 35,
    this.minItemWidth = 32,
    this.milestonesList,
    this.projectStart,
    this.projectEnd,
    this.laneMetrics = const TimelineLaneMetrics(),
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

  /// Total number of week columns the grid spans.
  int get _totalColumns =>
      _months.length * TimelineWindow.columnsPerMonth.toInt();

  /// Right edge of the axis, in column units.
  double get _axisEnd => _totalColumns.toDouble();

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
        oldWidget.minWeekWidth != widget.minWeekWidth ||
        oldWidget.rowHeightPx != widget.rowHeightPx ||
        oldWidget.minItemWidth != widget.minItemWidth ||
        oldWidget.laneMetrics != widget.laneMetrics) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Stretch the columns to fill the viewport; once the project is too
          // long to fit at `minWeekWidth`, the grid keeps that width and the
          // canvas scrolls horizontally instead.
          final double available = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : 0;
          final double weekWidth = math.max(
            widget.minWeekWidth,
            available / _totalColumns,
          );
          final double monthWidth = weekWidth * TimelineWindow.columnsPerMonth;
          final double totalWidth = weekWidth * _totalColumns;

          return SizedBox(
            height: effectiveHeight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: totalWidth,
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
                          width: totalWidth,
                          monthWidth: monthWidth,
                          height: widget.monthsHeaderHeight,
                          months: _months,
                        ),
                        TimelineWeeksHeader(
                          width: totalWidth,
                          monthWidth: monthWidth,
                          height: widget.weeksHeaderHeight,
                          weekWidth: weekWidth,
                          monthCount: _months.length,
                        ),
                        TimelineGridBody(
                          rows: totalRows,
                          width: totalWidth,
                          weekWidth: weekWidth,
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
                        weekWidth: weekWidth,
                        totalWidth: totalWidth,
                        monthsHeaderHeight: widget.monthsHeaderHeight,
                        weeksHeaderHeight: widget.weeksHeaderHeight,
                        isRTL: widget.textDirection == TextDirection.rtl,
                        metrics: widget.laneMetrics,
                        onMilestoneTap: widget.onMilestoneTap,
                        onSubactivityTap: widget.onSubactivityTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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

    // Converted at the narrowest column width: if columns end up wider, the
    // item only gets more room than the minimum, never less.
    final double minCols = widget.minItemWidth / widget.minWeekWidth;
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
  /// chips and the spacing between them — which is why both read the same
  /// [TimelineLaneMetrics] instead of each carrying its own copy.
  int _rowBandFor(int subCount) {
    final double contentHeight =
        widget.laneMetrics.contentHeightFor(subCount) +
        widget.laneMetrics.lanePadding * 2;

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
