import 'dart:math' as math;

import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:pms_system/pms_home/model/timeline_project_model.dart';
import 'package:pms_system/shared/pms_exports.dart';

// ===== Color palette (swap with your theme) =====
const Color kHeaderBg = Color(0xFFE9E9E9);
const Color kBorder = Color(0xFFE3E6EB);

// Arabic month names (Jan..Dec)
const List<String> kArabicMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

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

  // ---- Behavior ----
  final bool isRTL; // RTL layout for Arabic.

  // ---- Optional cell builder (for custom body contents) ----
  final Widget Function(int monthIndex, int weekIndex, int rowIndex)?
      cellBuilder;

  const ProjectTimeline({
    super.key,
    this.baseRowCount = 12,
    this.monthsHeaderHeight = 40,
    this.weeksHeaderHeight = 40,
    this.weekWidth = 35,
    this.rowHeightPx = 25,
    this.timelineProjects = const [],
    this.isRTL = true,
    this.cellBuilder,
  });

  double get _monthWidth => weekWidth * 4;

  double get _totalWidth => _monthWidth * 12;

  @override
  Widget build(BuildContext context) {
    // Base row height (fixed unit used even when canvas grows)
    final double rowH = rowHeightPx;

    // === Arrange projects (auto vertical placement with row bands) ===
    final _LayoutResult layout = _autoLayoutProjects(items: timelineProjects);

    // Compute rows required considering the deepest occupied row index
    final int totalRows =
        math.max(baseRowCount, (layout.maxRowIndex ?? -1) + 1);

    // Effective canvas height (auto-grow or fixed)
    final double effectiveHeight =
        (monthsHeaderHeight + weeksHeaderHeight + totalRows * rowH);

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
                    _MonthsHeader(
                      width: _totalWidth,
                      monthWidth: _monthWidth,
                      height: monthsHeaderHeight,
                    ),
                    _WeeksHeader(
                      width: _totalWidth,
                      monthWidth: _monthWidth,
                      height: weeksHeaderHeight,
                      weekWidth: weekWidth,
                    ),
                    _GridBody(
                      rows: totalRows,
                      width: _totalWidth,
                      monthWidth: _monthWidth,
                      weekWidth: weekWidth,
                      rowHeight: rowH,
                      cellBuilder: cellBuilder,
                    ),
                  ],
                ),

                // ===== Project lanes overlay =====
                ...layout.placed.map((p) {
                  final double bandTop =
                      monthsHeaderHeight + weeksHeaderHeight + p.row * rowH;
                  final double bandHeight = p.rowSpanRows * rowH;

                  // اختر padding حسب عدد الـ subprojects (0..2)
                  // final int subs = p.subCount;
                  final double perLanePadding = 6;
                  // subs == 0 ? 6 : (subs == 1 ? 6 : 6);

                  final double topPx = bandTop + perLanePadding;
                  final double laneH =
                      math.max(1, bandHeight - 2 * perLanePadding);

                  // Horizontal placement (RTL aware)
                  final double leftPx = isRTL
                      ? _totalWidth - (p.maxCol + 1) * weekWidth
                      : p.minCol * weekWidth;

                  final double laneWidth =
                      (p.maxCol - p.minCol + 1) * weekWidth;

                  return Positioned(
                    left: leftPx,
                    top: topPx,
                    width: laneWidth,
                    height: laneH,
                    child: _ProjectLane(
                      name: p.item.name,
                      items: p.item.subProjects ?? [],
                    ),
                  );
                }),
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
  _LayoutResult _autoLayoutProjects({required List<ProjectItem> items}) {
    final Map<int, List<_Span>> occupiedByRow = {};
    final List<_PlacedProject> placed = [];
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
        final list = (occupiedByRow[rr] ??= <_Span>[]);
        _addMergedSpan(list, _Span(startCol, endCol));
      }

      final int bottomRow = r + rowSpanRows - 1;
      if (maxRow == null || bottomRow > maxRow) maxRow = bottomRow;

      placed.add(_PlacedProject(
        item: item,
        row: r,
        minCol: startCol,
        maxCol: endCol,
        rowSpanRows: rowSpanRows,
        bottomRow: bottomRow,
        subCount: subs, // ← نحتفظ بالعدد لاستخدامه في اختيار الـ padding
      ));
    }

    return _LayoutResult(placed: placed, maxRowIndex: maxRow);
  }

  /// Fast overlap check across a contiguous band of rows using merged, sorted spans.
  bool _bandOverlapsFast({
    required Map<int, List<_Span>> occupied,
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
  bool _overlapsMerged(List<_Span>? spans, int s, int e) {
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
  void _addMergedSpan(List<_Span> spans, _Span span) {
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
    spans.insert(i, _Span(start, end));
  }

  /// Binary search: first index whose start >= x
  int _lowerBound(List<_Span> spans, int x) {
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

// ----- Helper data structures for layout bookkeeping -----

class _Span {
  final int s, e;

  _Span(this.s, this.e);
}

class _PlacedProject {
  final ProjectItem item;
  final int row; // top row of the reserved band
  final int minCol, maxCol;
  final int rowSpanRows; // band height in rows
  final int bottomRow; // inclusive
  final int subCount; // 0..2 (clamped)

  _PlacedProject({
    required this.item,
    required this.row,
    required this.minCol,
    required this.maxCol,
    required this.rowSpanRows,
    required this.bottomRow,
    required this.subCount,
  });
}

class _LayoutResult {
  final List<_PlacedProject> placed;
  final int? maxRowIndex; // deepest occupied row
  _LayoutResult({required this.placed, required this.maxRowIndex});
}

// ----- Rendering pieces: headers, grid body, and project lanes -----

/// Months header row (12 equally sized month cells).
class _MonthsHeader extends StatelessWidget {
  final double width, monthWidth, height;

  const _MonthsHeader({
    required this.width,
    required this.monthWidth,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: List.generate(12, (m) {
          return Container(
            width: monthWidth,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kHeaderBg.withValues(alpha: 0.5),
              border: Border.all(color: kBorder.withValues(alpha: 0.4)),
            ),
            child: Text(
              kArabicMonths[m],
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.color.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
    );
  }
}

/// Weeks header row (4 week cells per month, with optional grid lines).
class _WeeksHeader extends StatelessWidget {
  final double width, monthWidth, height, weekWidth;

  const _WeeksHeader({
    required this.width,
    required this.monthWidth,
    required this.height,
    required this.weekWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kBorder.withValues(alpha: 0.4), width: 1),
        ),
      ),
      child: Row(
        children: List.generate(12, (m) {
          return SizedBox(
            width: monthWidth,
            height: height,
            child: Row(
              children: List.generate(4, (w) {
                return SizedBox(
                  width: weekWidth,
                  height: height,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorder.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${w + 1}',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

/// Grid body (rows × 48 weeks). Optionally builds custom cells via cellBuilder.
class _GridBody extends StatelessWidget {
  final int rows;
  final double width, monthWidth, weekWidth, rowHeight;
  final Widget Function(int month, int week, int row)? cellBuilder;

  const _GridBody({
    required this.rows,
    required this.width,
    required this.monthWidth,
    required this.weekWidth,
    required this.rowHeight,
    this.cellBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows, (r) {
        return SizedBox(
          width: width,
          height: rowHeight,
          child: Row(
            children: List.generate(12, (m) {
              return SizedBox(
                width: monthWidth,
                height: rowHeight,
                child: Row(
                  children: List.generate(4, (w) {
                    return SizedBox(
                      width: weekWidth,
                      height: rowHeight,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: kBorder.withValues(alpha: 0.4)),
                        ),
                        child: cellBuilder?.call(m, w, r) ??
                            const SizedBox.shrink(),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

/// Project lane: line with circular end dots + rounded label + sub-project chips.
class _ProjectLane extends StatelessWidget {
  final String? name;
  final List<ProjectItem> items;

  const _ProjectLane({this.name, required this.items});

  @override
  Widget build(BuildContext context) {
    // Geometry to match intended visual style
    const double lineY = 6;
    const double lineThickness = 2;
    const double dotRadius = 4;
    const double labelTopGap = 8;
    const double pillPaddingV = 8;
    const double pillPaddingH = 10;
    const double pillRadius = 12;

    return LayoutBuilder(
      builder: (ctx, c) {
        final double w = c.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Horizontal line
            Positioned(
              top: lineY,
              left: 0,
              right: 0,
              child: Container(height: lineThickness, color: Colors.black),
            ),
            // Start dot
            Positioned(
              top: lineY - dotRadius,
              left: -dotRadius,
              child: Container(
                width: dotRadius * 2,
                height: dotRadius * 2,
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
              ),
            ),
            // End dot
            Positioned(
              top: lineY - dotRadius,
              left: w - dotRadius * 2,
              child: Container(
                width: dotRadius * 2,
                height: dotRadius * 2,
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
              ),
            ),

            // Label + subproject chips
            Positioned(
              top: lineY + labelTopGap,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null && name!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: pillPaddingV,
                        horizontal: pillPaddingH,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(pillRadius),
                      ),
                      child: Text(
                        name!,
                        textAlign: TextAlign.start,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.color.secondary,
                          fontSize: FontSizes.f10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (items.isNotEmpty) 8.sh,
                  if (items.isNotEmpty)
                    ...List.generate(
                      items.length >= 2 ? 2 : items.length,
                      (i) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: pillPaddingV,
                              horizontal: pillPaddingH,
                            ),
                            margin: EdgeInsets.only(
                                right: i == 0 ? 20 : 40, bottom: 8),
                            decoration: BoxDecoration(
                              color: context.color.tertiaryContainer
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(pillRadius),
                            ),
                            child: Text(
                              items[i].name ?? '',
                              textAlign: TextAlign.start,
                              style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.color.tertiaryContainer,
                                fontSize: FontSizes.f10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (items.length > 2 && i == 1) ...[
                            6.sw,
                            Text(
                              '+${items.length - 2}',
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.color.outlineVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
