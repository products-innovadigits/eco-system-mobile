import 'package:project_management/core/utility/project_management_exports.dart';

/// Thickness of a timeline grid line, in logical pixels.
const double kTimelineGridLineWidth = 1.0;

/// Grid body (rows × week columns).
///
/// The lattice is painted rather than built: a widget per cell meant
/// `rows × months × 4` containers — a couple of thousand render objects for a
/// two-year project, all rebuilt on every resize. A painter draws the same grid
/// with one line per boundary.
class TimelineGridBody extends StatelessWidget {
  final int rows;
  final double width, weekWidth, rowHeight;
  final int monthCount;

  /// Colour of the grid lines. Injected so the grid can follow a theme without
  /// the painter needing a [BuildContext].
  final Color? lineColor;

  const TimelineGridBody({
    super.key,
    required this.rows,
    required this.width,
    required this.weekWidth,
    required this.rowHeight,
    required this.monthCount,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: rows * rowHeight,
      child: CustomPaint(
        painter: _TimelineGridPainter(
          rows: rows,
          columns: monthCount * TimelineWindow.columnsPerMonth.toInt(),
          weekWidth: weekWidth,
          rowHeight: rowHeight,
          lineColor: lineColor ?? LightColor.timelineGridLine,
          devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
        ),
        isComplex: false,
        willChange: false,
      ),
    );
  }
}

class _TimelineGridPainter extends CustomPainter {
  final int rows;
  final int columns;
  final double weekWidth;
  final double rowHeight;
  final Color lineColor;
  final double devicePixelRatio;

  const _TimelineGridPainter({
    required this.rows,
    required this.columns,
    required this.weekWidth,
    required this.rowHeight,
    required this.lineColor,
    required this.devicePixelRatio,
  });

  /// Line width in whole device pixels, so a stroke never lands half on one
  /// physical pixel and half on the next.
  double get _physicalStroke => (kTimelineGridLineWidth * devicePixelRatio)
      .roundToDouble()
      .clamp(1.0, double.infinity);

  /// Column width is derived from the available space, so boundaries land on
  /// fractional offsets. Each line is snapped so that it covers whole physical
  /// pixels: an odd-width stroke centres on a pixel centre, an even-width one
  /// on a pixel boundary. Without this the grid smears and reads as invisible.
  double _snapCenter(double value) {
    final double physical = value * devicePixelRatio;
    final double snapped = _physicalStroke % 2 == 1
        ? physical.floorToDouble() + 0.5
        : physical.roundToDouble();
    return snapped / devicePixelRatio;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double stroke = _physicalStroke / devicePixelRatio;
    if (rows <= 0 ||
        columns <= 0 ||
        size.width <= stroke ||
        size.height <= stroke) {
      return;
    }

    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = stroke
      ..isAntiAlias = false;

    // Keep the outer lines fully inside the canvas, or half of each would be
    // clipped and the border would read thinner than the inner grid.
    final double half = stroke / 2;

    // Vertical lines: every column boundary, both outer edges included.
    for (int c = 0; c <= columns; c++) {
      final double dx = _snapCenter(
        c * weekWidth,
      ).clamp(half, size.width - half);
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    // Horizontal lines: every row boundary, both outer edges included.
    for (int r = 0; r <= rows; r++) {
      final double dy = _snapCenter(
        r * rowHeight,
      ).clamp(half, size.height - half);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(_TimelineGridPainter oldDelegate) =>
      oldDelegate.rows != rows ||
      oldDelegate.columns != columns ||
      oldDelegate.weekWidth != weekWidth ||
      oldDelegate.rowHeight != rowHeight ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.devicePixelRatio != devicePixelRatio;
}
