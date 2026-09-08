import 'package:project_management/core/utility/project_management_exports.dart';

/// The date range the timeline is drawn for, and the axis that maps a date to a
/// horizontal position on it.
///
/// The axis is measured in **column units**: every month is
/// [columnsPerMonth] columns wide, one per week cell of the header, and a date
/// is snapped to its week bucket:
/// - W1: days 1-7
/// - W2: days 8-14
/// - W3: days 15-21
/// - W4: days 22-end of month
///
/// A column is therefore the smallest unit the timeline can express: two items
/// that fall in the same week render at the same place and the same width,
/// whatever their real duration.
///
/// Column 0 is the first day of the month [start] falls in, because the grid
/// always draws whole months.
class TimelineWindow {
  /// Inclusive bounds, normalized to day precision.
  final DateTime start;
  final DateTime end;

  /// First day of [start]'s month — the origin of the axis.
  final DateTime origin;

  static const double columnsPerMonth = 4;

  TimelineWindow._(this.start, this.end)
    : origin = DateTime(start.year, start.month, 1);

  /// Resolves the window from the project dates *and the data itself*.
  ///
  /// The project dates are only hints: they are often null, and milestones are
  /// regularly maintained outside them. Anything left outside the window is
  /// clamped away by [spanOf], so deriving the bounds from every date we are
  /// about to draw is what keeps milestones from silently disappearing.
  factory TimelineWindow.resolve({
    DateTime? projectStart,
    DateTime? projectEnd,
    List<MilestoneModel> milestones = const [],
  }) {
    DateTime? min;
    DateTime? max;

    void consider(DateTime? date) {
      if (date == null) return;
      final DateTime day = DateUtils.dateOnly(date);
      if (min == null || day.isBefore(min!)) min = day;
      if (max == null || day.isAfter(max!)) max = day;
    }

    consider(projectStart);
    consider(projectEnd);
    for (final milestone in milestones) {
      consider(milestone.startDate);
      consider(milestone.endDate);
      for (final sub in milestone.subActivities ?? const <SubActivityModel>[]) {
        consider(sub.startDate);
        consider(sub.endDate);
      }
    }

    final DateTime resolvedStart = min ?? DateUtils.dateOnly(DateTime.now());
    final DateTime resolvedEnd =
        max ?? DateTime(resolvedStart.year, resolvedStart.month + 3, 1);

    return TimelineWindow._(
      resolvedStart,
      resolvedEnd.isBefore(resolvedStart) ? resolvedStart : resolvedEnd,
    );
  }

  /// Week bucket of [date] inside its month, 1..4.
  static int weekOfMonth(DateTime date) {
    final int day = date.day;
    if (day <= 7) return 1;
    if (day <= 14) return 2;
    if (day <= 21) return 3;
    return 4;
  }

  /// Position of [date] on the axis, in column units.
  ///
  /// [endOfCell] places the date at the *end* of its week cell, so that an item
  /// starting and ending in the same week is one column wide.
  double offsetOf(DateTime date, {bool endOfCell = false}) {
    final int monthIndex =
        (date.year - origin.year) * 12 + (date.month - origin.month);
    return monthIndex * columnsPerMonth +
        (weekOfMonth(date) - 1) +
        (endOfCell ? 1 : 0);
  }

  /// Maps a date range onto the axis, clamped to the window.
  /// Returns null when the range is empty or falls entirely outside.
  DateSpan? spanOf(DateTime? from, DateTime? to) {
    if (from == null || to == null) return null;

    final DateTime a = DateUtils.dateOnly(from);
    final DateTime b = DateUtils.dateOnly(to);

    // Tolerate reversed ranges coming from the API.
    final DateTime rangeStart = a.isAfter(b) ? b : a;
    final DateTime rangeEnd = a.isAfter(b) ? a : b;

    final DateTime clampedStart = rangeStart.isBefore(start)
        ? start
        : rangeStart;
    final DateTime clampedEnd = rangeEnd.isAfter(end) ? end : rangeEnd;
    if (clampedStart.isAfter(clampedEnd)) return null;

    return DateSpan(
      offsetOf(clampedStart),
      offsetOf(clampedEnd, endOfCell: true),
    );
  }
}

/// Date pattern used by the timeline tooltips, e.g. `05/12/2027`.
const String kTimelineDateFormat = 'dd/MM/yyyy';

/// Formats an item's dates for its tooltip, one labelled line each:
///
/// ```
/// تاريخ البدء: 05/12/2027
/// تاريخ الانتهاء: 10/01/2028
/// ```
///
/// Week cells are the smallest unit the grid can express, so a bar's width only
/// tells the user which weeks an item touches. The exact dates are what the
/// snapping loses, which is why every tooltip carries them.
///
/// Each date is labelled rather than written as a `start : end` range: the two
/// dates are number runs, and in an RTL paragraph the bidi algorithm reorders
/// them, so a bare range can read end-first. Each value is also wrapped in a
/// left-to-right isolate so it never breaks apart against its label.
String? formatTimelineDateRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return null;

  final List<String> lines = [];

  void addLine(String labelKey, DateTime? date) {
    if (date == null) return;
    final String value = date.format(kTimelineDateFormat);
    if (value.isEmpty) return;
    lines.add('${allTranslations.text(labelKey).trim()}: \u2066$value\u2069');
  }

  addLine(LocaleKeys.start_date, start);
  addLine(LocaleKeys.end_date, end);

  return lines.isEmpty ? null : lines.join('\n');
}

/// A range on the timeline axis, in column units. [end] is exclusive.
class DateSpan {
  final double start;
  final double end;

  const DateSpan(this.start, this.end);

  double get width => end - start;
}

/// Generate list of months from the window start to the window end.
/// Each entry includes the month name and year.
class ProjectMonth {
  final int year;
  final int month; // 1-12
  final String displayName; // e.g., "يناير (2025)"

  ProjectMonth(this.year, this.month, this.displayName);

  static List<ProjectMonth> generateMonths(
    DateTime projectStart,
    DateTime projectEnd,
  ) {
    final List<ProjectMonth> months = [];

    final start = DateTime(projectStart.year, projectStart.month, 1);
    final end = DateTime(projectEnd.year, projectEnd.month, 1);

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

    DateTime current = start;
    while (current.isBefore(end) ||
        (current.year == end.year && current.month == end.month)) {
      final monthName = kArabicMonths[current.month - 1];
      months.add(
        ProjectMonth(
          current.year,
          current.month,
          '$monthName (${current.year})',
        ),
      );

      // Move to next month
      if (current.month == 12) {
        current = DateTime(current.year + 1, 1, 1);
      } else {
        current = DateTime(current.year, current.month + 1, 1);
      }
    }

    // Ensure at least 4 months are shown
    const int minMonths = 4;
    if (months.length < minMonths) {
      DateTime lastMonth = months.isNotEmpty
          ? DateTime(months.last.year, months.last.month, 1)
          : start;

      while (months.length < minMonths) {
        // Move to next month
        if (lastMonth.month == 12) {
          lastMonth = DateTime(lastMonth.year + 1, 1, 1);
        } else {
          lastMonth = DateTime(lastMonth.year, lastMonth.month + 1, 1);
        }

        final monthName = kArabicMonths[lastMonth.month - 1];
        months.add(
          ProjectMonth(
            lastMonth.year,
            lastMonth.month,
            '$monthName (${lastMonth.year})',
          ),
        );
      }
    }

    return months;
  }
}
