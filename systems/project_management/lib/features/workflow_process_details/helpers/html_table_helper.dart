import 'package:core_system/core/helpers/text_helper.dart';

class HtmlTableHelper {
  static List<List<String>> parseHtmlTable(String htmlContent) {
    final tableRegex = RegExp(r'<table[^>]*>(.*?)</table>', dotAll: true);
    final tableMatch = tableRegex.firstMatch(htmlContent);

    if (tableMatch == null) return [];

    final tableContent = tableMatch.group(1) ?? '';
    final rowRegex = RegExp(r'<tr[^>]*>(.*?)</tr>', dotAll: true);
    final cellRegex = RegExp(r'<t[dh][^>]*>(.*?)</t[dh]>', dotAll: true);

    final rows = <List<String>>[];
    final rowMatches = rowRegex.allMatches(tableContent);

    for (final rowMatch in rowMatches) {
      final rowContent = rowMatch.group(1) ?? '';
      final cellMatches = cellRegex.allMatches(rowContent);
      final cells = <String>[];

      for (final cellMatch in cellMatches) {
        final cellContent = cellMatch.group(1) ?? '';
        final cleanContent = _cleanHtmlContent(cellContent);
        cells.add(cleanContent);
      }

      if (cells.isNotEmpty) {
        rows.add(cells);
      }
    }
    return rows;
  }

  static String _cleanHtmlContent(String content) {
    String cleaned = content.replaceAll(RegExp(r'style\s*=\s*"[^"]*"'), '');
    cleaned = cleaned.replaceAll(RegExp(r"style\s*=\s*'[^']*'"), '');
    cleaned = cleaned.replaceAll(RegExp(r'color\s*=\s*"[^"]*"'), '');
    cleaned = cleaned.replaceAll(RegExp(r"color\s*=\s*'[^']*'"), '');
    cleaned = TextHelper.paresHTML(cleaned).trim();
    return cleaned;
  }

  static bool hasTable(String htmlContent) {
    final tableRegex = RegExp(r'<table[^>]*>(.*?)</table>', dotAll: true);
    return tableRegex.firstMatch(htmlContent) != null;
  }

  static String getPlainText(String htmlContent) {
    return TextHelper.paresHTML(htmlContent);
  }
}
