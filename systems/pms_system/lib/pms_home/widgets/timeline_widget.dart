import 'dart:math' as math;

import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:pms_system/pms_home/model/timeline_project_model.dart';
import 'package:pms_system/shared/pms_exports.dart';

// ===== colors (swap with your theme) =====
const Color kHeaderBg = Color(0xFFE9E9E9);
const Color kBorder = Color(0xFFE3E6EB);

const Color kProjectLine = Color(0xFF0C2D6B);
const Color kProjectColor = Color(0xFF2D6DF6);

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

/// Convert 1-based (month 1..12, week 1..4) to zero-based column index (0..47).
int _colFrom1Based(int month1, int week1) {
  assert(month1 >= 1 && month1 <= 12);
  assert(week1 >= 1 && week1 <= 4);
  return (month1 - 1) * 4 + (week1 - 1);
}

class TimelineWidget extends StatelessWidget {
  final double height;
  final int rows;
  final double headerHeight;
  final double weeksHeight;
  final double weekCellWidth;
  final double? rowHeight;
  final bool showWeekDividers;
  final List<ProjectItem> projects;
  final bool autoPlaceProjects;
  final bool autoGrowHeight;
  final bool rtlLayout;

  /// Optional body cell builder
  final Widget Function(int month, int week, int row)? cellBuilder;

  const TimelineWidget({
    super.key,
    required this.height,
    this.rows = 10,
    this.headerHeight = 40,
    this.weeksHeight = 40,
    this.weekCellWidth = 30,
    this.rowHeight,
    this.showWeekDividers = true,
    this.projects = const [],
    this.autoPlaceProjects = true,
    this.autoGrowHeight = true,
    this.rtlLayout = true,
    this.cellBuilder,
  })  : assert(height > 0),
        assert(rows > 0);

  double get _monthWidth => weekCellWidth * 4;

  double get _tableWidth => _monthWidth * 12;

  @override
  Widget build(BuildContext context) {
    // Base row height (stays constant even when height grows)
    final double baseRowH =
        rowHeight ?? ((height - headerHeight - weeksHeight) / rows);

    // === Arrange projects into rows (with auto placement & vertical bands) ===
    final _Arrangement arr = _arrangeProjects(
      items: projects,// move by 2 rows each overlap
    );

    // Total rows needed (consider base rows and the bottom of the deepest band)
    final int totalRows = math.max(rows, (arr.maxRowIndex ?? -1) + 1);

    // Effective height (autogrow or fixed)
    final double effectiveHeight = autoGrowHeight
        ? (headerHeight + weeksHeight + totalRows * baseRowH)
        : height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: effectiveHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: _tableWidth,
            height: effectiveHeight, // important for Stack positioning
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // === Base table (header + weeks + body) ===
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _HeaderRow(
                      width: _tableWidth,
                      monthWidth: _monthWidth,
                      height: headerHeight,
                    ),
                    _WeeksRow(
                      width: _tableWidth,
                      monthWidth: _monthWidth,
                      height: weeksHeight,
                      weekCellWidth: weekCellWidth,
                      showWeekDividers: showWeekDividers,
                    ),
                    _BodyGrid(
                      rows: totalRows,
                      width: _tableWidth,
                      monthWidth: _monthWidth,
                      weekCellWidth: weekCellWidth,
                      rowHeight: baseRowH,
                      showWeekDividers: showWeekDividers,
                      cellBuilder: cellBuilder,
                    ),
                  ],
                ),

                // === Overlay projects (drawn on top) ===
                ...arr.placed.map((p) {
                  final double rowTop =
                      headerHeight + weeksHeight + p.row * baseRowH;

                  // RTL-aware horizontal placement
                  final double left = rtlLayout
                      ? _tableWidth - (p.maxCol + 1) * weekCellWidth
                      : p.minCol * weekCellWidth;

                  final double width =
                      (p.maxCol - p.minCol + 1) * weekCellWidth;

                  // Height spans the whole reserved band for this project
                  final double heightPx = baseRowH * p.rowSpanRows;

                  return Positioned(
                    left: left,
                    top: rowTop,
                    width: width,
                    height: heightPx,
                    child: _ProjectBar(
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

  // ---------- arrangement (auto placement with vertical bands) ----------

  _Arrangement _arrangeProjects({
    required List<ProjectItem> items,
  }) {
    final Map<int, List<_Interval>> occupied = {};
    final List<_Placed> placed = [];
    int? maxRow;

    for (final item in items) {
      final int a = _colFrom1Based(item.startMonth, item.startWeek);
      final int b = _colFrom1Based(item.endMonth, item.endWeek);
      final int startCol = math.min(a, b);
      final int endCol   = math.max(a, b);

      final int subCount = (item.subProjects?.length ?? 0);
      int rowSeparation(int subCount) {
        if (subCount == 0) return 3;
        if (subCount == 1) return 4;
        return 5;
      }

      // Get spacing between projects dynamically
      final int rowStep = rowSeparation(subCount); // <── here

      // Reserve a CONTIGUOUS band: 1 main row + (rowStep-1) extra rows for spacing
      final int rowSpanRows = rowStep;

      // Find a free contiguous band
      int r = item.preferredRow ?? 0;
      while (_hasOverlapInBand(
        occupied: occupied,
        topRow: r,
        bandRows: rowSpanRows,
        s: startCol,
        e: endCol,
      )) {
        r += rowStep;
      }

      // Mark every row in the band as occupied
      for (int rr = r; rr < r + rowSpanRows; rr++) {
        (occupied[rr] ??= []).add(_Interval(startCol, endCol));
      }

      final int bottomRow = r + rowSpanRows - 1;
      if (maxRow == null || bottomRow > maxRow) maxRow = bottomRow;

      placed.add(_Placed(
        item: item,
        row: r,
        minCol: startCol,
        maxCol: endCol,
        rowSpanRows: rowSpanRows,
        bottomRow: bottomRow,
      ));
    }

    return _Arrangement(placed: placed, maxRowIndex: maxRow);
  }



  /// Overlap across a CONTIGUOUS band of rows [topRow .. topRow+bandRows-1]
  bool _hasOverlapInBand({
    required Map<int, List<_Interval>> occupied,
    required int topRow,
    required int bandRows,
    required int s,
    required int e,
  }) {
    for (int rr = topRow; rr < topRow + bandRows; rr++) {
      final list = occupied[rr];
      if (_hasOverlap(list, s, e)) return true;
    }
    return false;
  }

  bool _hasOverlap(List<_Interval>? intervals, int s, int e) {
    if (intervals == null) return false;
    for (final it in intervals) {
      if (!(e < it.s || s > it.e)) return true; // any overlap
    }
    return false;
  }
}

class _Interval {
  final int s, e;

  _Interval(this.s, this.e);
}

class _Placed {
  final ProjectItem item;
  final int row; // top row of the reserved band
  final int minCol, maxCol;
  final int rowSpanRows; // height in rows = 1 + 2 * subCount
  final int bottomRow; // inclusive

  _Placed({
    required this.item,
    required this.row,
    required this.minCol,
    required this.maxCol,
    required this.rowSpanRows,
    required this.bottomRow,
  });
}

class _Arrangement {
  final List<_Placed> placed;
  final int? maxRowIndex; // bottom-most occupied row across all items
  _Arrangement({required this.placed, required this.maxRowIndex});
}

// ---------- rendering pieces ----------

class _HeaderRow extends StatelessWidget {
  final double width, monthWidth, height;

  const _HeaderRow({
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

class _WeeksRow extends StatelessWidget {
  final double width, monthWidth, height, weekCellWidth;
  final bool showWeekDividers;

  const _WeeksRow({
    required this.width,
    required this.monthWidth,
    required this.height,
    required this.weekCellWidth,
    required this.showWeekDividers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration:  BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kBorder.withValues(alpha: 0.4), width: 1), // separator above body
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
                  width: weekCellWidth,
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

class _BodyGrid extends StatelessWidget {
  final int rows;
  final double width, monthWidth, weekCellWidth, rowHeight;
  final bool showWeekDividers;
  final Widget Function(int month, int week, int row)? cellBuilder;

  const _BodyGrid({
    required this.rows,
    required this.width,
    required this.monthWidth,
    required this.weekCellWidth,
    required this.rowHeight,
    required this.showWeekDividers,
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
                      width: weekCellWidth,
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

/// A project bar: line with circular dots + rounded pill label + subproject chips.
class _ProjectBar extends StatelessWidget {
  final String? name;
  final List<ProjectItem> items;

  const _ProjectBar({
    this.name,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // layout numbers to match your screenshot feel
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
            // Line
            Positioned(
              top: lineY,
              left: 0,
              right: 0,
              child: Container(height: lineThickness, color: kProjectLine),
            ),
            // Dots at ends
            Positioned(
              top: lineY - dotRadius,
              left: -dotRadius,
              child: Container(
                width: dotRadius * 2,
                height: dotRadius * 2,
                decoration: const BoxDecoration(
                    color: kProjectLine, shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: lineY - dotRadius,
              left: w - dotRadius * 2,
              child: Container(
                width: dotRadius * 2,
                height: dotRadius * 2,
                decoration: const BoxDecoration(
                    color: kProjectLine, shape: BoxShape.circle),
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
                              color:
                                  context.color.tertiaryContainer.withValues(alpha: 0.2),
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
                              items.length > 2 ? '+${items.length - 2}' : '',
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
