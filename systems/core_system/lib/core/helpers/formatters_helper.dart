class FormattersHelper {
  static String formatTime(String? lastChangeTime) {
    if (lastChangeTime == null) return "10:00 AM";
    try {
      final dateTime = DateTime.parse(lastChangeTime);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return "$displayHour:$minute $period";
    } catch (e) {
      return "10:00 AM";
    }
  }

  static String formatDate(
    String? lastChangeTime, {
    bool isDate = false,
    bool isMonth = false,
  }) {
    if (lastChangeTime == null) return isDate ? "17" : "ابريل";
    try {
      final dateTime = DateTime.parse(lastChangeTime);
      if (isDate) {
        return dateTime.day.toString();
      } else if (isMonth) {
        const months = [
          "يناير",
          "فبراير",
          "مارس",
          "ابريل",
          "مايو",
          "يونيو",
          "يوليو",
          "أغسطس",
          "سبتمبر",
          "أكتوبر",
          "نوفمبر",
          "ديسمبر",
        ];
        return months[dateTime.month - 1];
      }
      return dateTime.day.toString();
    } catch (e) {
      return isDate ? "17" : "ابريل";
    }
  }
}
