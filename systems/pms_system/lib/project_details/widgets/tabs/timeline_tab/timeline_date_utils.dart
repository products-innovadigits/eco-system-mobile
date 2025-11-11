/// Week bucket utility: converts a DateTime to a week cell index within the project timeline.
/// 
/// Week buckets:
/// - W1: days 1-7
/// - W2: days 8-14
/// - W3: days 15-21
/// - W4: days 22-end of month
/// 
/// Returns (monthIndex, weekInMonth 1..4) relative to projectStart.
/// monthIndex is 0-based from projectStart (0 = first month of project).
class WeekCell {
  final int monthIndex; // 0-based from projectStart
  final int weekInMonth; // 1-4

  WeekCell(this.monthIndex, this.weekInMonth);

  /// Convert DateTime to week cell relative to projectStart.
  static WeekCell? indexOf(DateTime? dt, DateTime projectStart) {
    if (dt == null) return null;

    // Normalize to start of day
    final date = DateTime(dt.year, dt.month, dt.day);
    final start = DateTime(projectStart.year, projectStart.month, projectStart.day);

    if (date.isBefore(start)) return null;

    // Calculate months difference
    int monthIndex = 0;
    
    // If date is in the same month as projectStart, monthIndex is 0
    if (date.year == start.year && date.month == start.month) {
      monthIndex = 0;
    } else {
      // Calculate months from projectStart
      DateTime current = DateTime(start.year, start.month, 1);
      
      while (current.year < date.year || 
             (current.year == date.year && current.month < date.month)) {
        monthIndex++;
        if (current.month == 12) {
          current = DateTime(current.year + 1, 1, 1);
        } else {
          current = DateTime(current.year, current.month + 1, 1);
        }
      }
    }

    // Calculate week within the month
    // W1: days 1-7, W2: days 8-14, W3: days 15-21, W4: days 22-end
    final day = date.day;
    int weekInMonth;
    if (day >= 1 && day <= 7) {
      weekInMonth = 1;
    } else if (day >= 8 && day <= 14) {
      weekInMonth = 2;
    } else if (day >= 15 && day <= 21) {
      weekInMonth = 3;
    } else {
      weekInMonth = 4;
    }

    return WeekCell(monthIndex, weekInMonth);
  }

  /// Convert week cell to zero-based column index (0 = first week of project).
  int toColumnIndex() {
    return monthIndex * 4 + (weekInMonth - 1);
  }

  /// Create WeekCell from column index.
  static WeekCell fromColumnIndex(int colIndex) {
    final monthIndex = colIndex ~/ 4;
    final weekInMonth = (colIndex % 4) + 1;
    return WeekCell(monthIndex, weekInMonth);
  }
}

/// Get the span (startCol, endCol) for a date range, inclusive.
/// Returns null if dates are invalid or outside project window.
class DateSpan {
  final int startCol;
  final int endCol;

  DateSpan(this.startCol, this.endCol);

  int get width => endCol - startCol + 1;

  static DateSpan? fromDates(
    DateTime? startDate,
    DateTime? endDate,
    DateTime projectStart,
    DateTime projectEnd,
  ) {
    if (startDate == null || endDate == null) return null;

    // Normalize dates to start of day
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final projStart = DateTime(projectStart.year, projectStart.month, projectStart.day);
    final projEnd = DateTime(projectEnd.year, projectEnd.month, projectEnd.day);

    // Ensure start <= end (swap if reversed)
    final actualStart = start.isBefore(end) || start.isAtSameMomentAs(end) ? start : end;
    final actualEnd = start.isBefore(end) || start.isAtSameMomentAs(end) ? end : start;

    // Clamp to project window
    final clampedStart = actualStart.isBefore(projStart) ? projStart : actualStart;
    final clampedEnd = actualEnd.isAfter(projEnd) ? projEnd : actualEnd;

    if (clampedStart.isAfter(clampedEnd)) return null;

    final startCell = WeekCell.indexOf(clampedStart, projStart);
    final endCell = WeekCell.indexOf(clampedEnd, projStart);

    if (startCell == null || endCell == null) return null;

    final startCol = startCell.toColumnIndex();
    final endCol = endCell.toColumnIndex();

    // Ensure startCol <= endCol
    return DateSpan(
      startCol < endCol ? startCol : endCol,
      startCol < endCol ? endCol : startCol,
    );
  }
}

/// Generate list of months from projectStart to projectEnd.
/// Each entry includes the month name and year (with year suffix if month repeats).
class ProjectMonth {
  final int year;
  final int month; // 1-12
  final String displayName; // e.g., "يناير" or "يناير (2025)"

  ProjectMonth(this.year, this.month, this.displayName);

  static List<ProjectMonth> generateMonths(DateTime projectStart, DateTime projectEnd) {
    final List<ProjectMonth> months = [];
    final Map<String, int> monthNameCount = {}; // Track occurrences of each month name

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
      final key = monthName;
      
      monthNameCount[key] = (monthNameCount[key] ?? 0) + 1;
      final count = monthNameCount[key]!;

      String displayName;
      if (count > 1) {
        // Append year if this month name appears multiple times
        displayName = '$monthName (${current.year})';
      } else {
        displayName = monthName;
      }

      months.add(ProjectMonth(current.year, current.month, displayName));

      // Move to next month
      if (current.month == 12) {
        current = DateTime(current.year + 1, 1, 1);
      } else {
        current = DateTime(current.year, current.month + 1, 1);
      }
    }

    return months;
  }
}

