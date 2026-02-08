import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:project_management/core/utility/project_management_exports.dart';

import 'html_content_helper.dart';

/// Renders HTML content with read-only form fields for viewing.
/// Supports paragraphs, tables, and various field types (text, number, email, url, date).
/// Fields are identified by `data-id` attributes in HTML shortcode containers.
/// All fields are displayed as read-only text inputs (view-only mode).
class EditableHtmlRenderer extends StatelessWidget {
  // -------------------------
  // Properties
  // -------------------------

  /// The HTML content to render
  final String htmlContent;

  /// Field definitions mapped by field ID.
  /// (based on how you parse it).
  final Map<String, dynamic> fields;

  /// Text editing controllers for each field ID (same as data-id in HTML).
  final Map<String, TextEditingController> controllers;

  /// Optional callback (deprecated - fields are now read-only).
  /// Kept for backward compatibility but will not be invoked.
  @Deprecated('Fields are read-only, this callback is no longer used')
  final void Function(String id, String value)? onFieldValueChanged;

  const EditableHtmlRenderer({
    super.key,
    required this.htmlContent,
    required this.fields,
    required this.controllers,
    this.onFieldValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fragment = html_parser.parseFragment(htmlContent);
    final blocks = _buildBlocks(fragment.nodes, context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }

  // -------------------------
  // Block-level builders
  // -------------------------

  /// Builds block-level widgets (paragraphs, tables, line breaks) from HTML nodes.
  List<Widget> _buildBlocks(List<dom.Node> nodes, BuildContext context) {
    final out = <Widget>[];

    for (final node in nodes) {
      // Handle text nodes
      if (node is dom.Text) {
        final t = HtmlContentHelper.cleanText(node.text).trim();
        if (t.isNotEmpty) {
          out.add(Text(t, style: Theme.of(context).textTheme.bodyMedium));
        }
        continue;
      }

      // Skip non-element nodes
      if (node is! dom.Element) continue;

      // Build widgets based on element type
      switch (node.localName) {
        case 'p':
          out.add(_buildParagraph(node, context));
          out.add(
            const SizedBox(height: HtmlContentHelper.paragraphBottomSpacing),
          );
          break;

        case 'table':
          out.add(_buildTable(node, context));
          out.add(const SizedBox(height: HtmlContentHelper.tableBottomSpacing));
          break;

        case 'br':
          out.add(const SizedBox(height: HtmlContentHelper.lineBreakSpacing));
          break;

        default:
          // Recursively process child nodes for unknown elements
          out.addAll(_buildBlocks(node.nodes, context));
          break;
      }
    }

    return out;
  }

  /// Builds a paragraph widget from a <p> element.
  Widget _buildParagraph(dom.Element p, BuildContext context) {
    final parts = _buildInline(p.nodes, context);

    if (parts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: HtmlContentHelper.inlineSpacing,
      runSpacing: HtmlContentHelper.paragraphRunSpacing,
      children: parts,
    );
  }

  /// Builds inline widgets (text, fields, links, etc.) from HTML nodes.
  List<Widget> _buildInline(List<dom.Node> nodes, BuildContext context) {
    final out = <Widget>[];

    for (final node in nodes) {
      // Handle text nodes
      if (node is dom.Text) {
        final t = HtmlContentHelper.cleanText(node.text);
        if (t.trim().isNotEmpty) {
          out.add(Text(t, style: Theme.of(context).textTheme.bodyMedium));
        }
        continue;
      }

      // Skip non-element nodes
      if (node is! dom.Element) continue;

      // Check if this is a shortcode container (editable field)
      final isShortcode = node.classes.contains('builder-shortcode-container');
      final id = node.attributes['data-id'];

      // Replace <span class="builder-shortcode-container" data-id="..."> with a field widget
      if (isShortcode && id != null && fields.containsKey(id)) {
        out.add(_buildFieldWidget(id, fields[id], context));
        continue;
      }

      // Handle line breaks
      if (node.localName == 'br') {
        out.add(const SizedBox(width: double.infinity));
        continue;
      }

      // Recursively process child nodes for other inline elements (spans, links, strong, etc.)
      out.addAll(_buildInline(node.nodes, context));
    }

    return out;
  }

  // -------------------------
  // Table rendering
  // -------------------------

  /// Builds a DataTable widget from an HTML <table> element.
  /// Only uses styling that comes from the HTML response.
  Widget _buildTable(dom.Element table, BuildContext context) {
    final rows = table.getElementsByTagName('tr');
    if (rows.isEmpty) return const SizedBox.shrink();

    final headerCells = rows.first.children
        .where((c) => c.localName == 'th' || c.localName == 'td')
        .toList();
    final colCount = headerCells.length;

    final columns = List.generate(colCount, (i) {
      final headerText = HtmlContentHelper.cleanText(
        headerCells[i].text,
      ).trim();
      return DataColumn(
        label: Text(
          headerText.isEmpty ? ' ' : headerText,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      );
    });

    // Header background from response only
    final headerBg = _elementBg(rows.first) ?? _elementBg(table);

    // Extract border from HTML response if present
    final tableBorder = _elementBorder(table);

    final dataRows = <DataRow>[];

    for (final r in rows.skip(1)) {
      final rowBg = _elementBg(r) ?? _elementBg(table);

      final cellEls = r.children
          .where((c) => c.localName == 'td' || c.localName == 'th')
          .toList();

      final cells = <DataCell>[];

      for (var i = 0; i < colCount; i++) {
        final cellEl = i < cellEls.length ? cellEls[i] : null;

        // Use cell background, then row background, then null (no color from code)
        final cellBg = cellEl != null ? (_elementBg(cellEl) ?? rowBg) : rowBg;

        // Extract padding from HTML response if present
        final cellPadding = cellEl != null
            ? _elementPadding(cellEl)
            : EdgeInsets.zero;

        // Only wrap in Container if there's a background color or padding from response
        final cellContent = _buildTableCell(cellEl, context);
        final cellWidget = (cellBg != null || cellPadding != EdgeInsets.zero)
            ? Container(
                color: cellBg ?? Colors.transparent,
                padding: cellPadding,
                child: cellContent,
              )
            : cellContent;

        cells.add(DataCell(cellWidget));
      }

      dataRows.add(
        DataRow(
          color: rowBg != null
              ? WidgetStateProperty.all(rowBg)
              : WidgetStateProperty.all(Colors.transparent),
          cells: cells,
        ),
      );
    }

    // Always create a border with only vertical lines, removing all horizontal borders
    // Even if tableBorder is null, we'll create one with no borders
    final finalBorder =
        tableBorder ??
        TableBorder(
          left: BorderSide.none,
          right: BorderSide.none,
          top: BorderSide.none,
          bottom: BorderSide.none,
          horizontalInside: BorderSide.none,
          verticalInside: BorderSide.none,
        );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        horizontalMargin: 8,
        headingRowColor: headerBg != null
            ? WidgetStateProperty.all(headerBg)
            : WidgetStateProperty.all(Colors.transparent),
        dataRowColor: WidgetStateProperty.all(Colors.transparent),
        border: finalBorder,
        columns: columns,
        rows: dataRows,
      ),
    );
  }

  /// Builds the content for a table cell.
  /// Only represents content from the response.
  Widget _buildTableCell(dom.Element? cellEl, BuildContext context) {
    if (cellEl == null) return const SizedBox.shrink();

    // Build inline content without any added margins
    final parts = _buildInline(cellEl.nodes, context);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: HtmlContentHelper.tableCellMinWidth,
      ),
      child: Wrap(
        spacing: HtmlContentHelper.inlineSpacing,
        runSpacing: HtmlContentHelper.paragraphRunSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: parts,
      ),
    );
  }

  // -------------------------
  // Field widget builders
  // -------------------------

  /// Builds a read-only input widget based on the field type.
  /// All fields are displayed as read-only (view-only mode).
  /// Only represents content from the response.
  Widget _buildFieldWidget(String id, dynamic field, BuildContext context) {
    // final type = HtmlContentHelper.readFieldType(field);
    final placeholder = HtmlContentHelper.readFieldPlaceholder(field);
    final controller = controllers.putIfAbsent(
      id,
      () =>
          TextEditingController(text: HtmlContentHelper.readFieldValue(field)),
    );
    return _input(
      id: id,
      field: field,
      controller: controller,
      hint: placeholder,
      // keyboardType: TextInputType.number,
      context: context,
    );

    // switch (type)
    // {
    //   case 'number':
    //     return _input(
    //       id: id,
    //       field: field,
    //       controller: controller,
    //       hint: placeholder,
    //       keyboardType: TextInputType.number,
    //       context: context,
    //     );
    //
    //   case 'email':
    //     return _input(
    //       id: id,
    //       field: field,
    //       controller: controller,
    //       hint: placeholder,
    //       keyboardType: TextInputType.emailAddress,
    //       context: context,
    //     );
    //
    //   case 'url':
    //     return _input(
    //       id: id,
    //       field: field,
    //       controller: controller,
    //       hint: placeholder,
    //       keyboardType: TextInputType.url,
    //       context: context,
    //     );
    //
    //   case 'date':
    //     return _dateInput(
    //       id: id,
    //       field: field,
    //       controller: controller,
    //       hint: placeholder,
    //       context: context,
    //     );
    //
    //   case 'text':
    //   default:
    //     return _input(
    //       id: id,
    //       field: field,
    //       controller: controller,
    //       hint: placeholder,
    //       context: context,
    //     );
    // }
  }

  /// Builds a read-only text input field widget for viewing field values.
  Widget _input({
    required String id,
    required dynamic field,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required BuildContext context,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: HtmlContentHelper.inputFieldMinWidth,
        maxWidth: HtmlContentHelper.inputFieldMaxWidth,
        maxHeight: 40, // Limit height to fit table cells
      ),
      child: CustomTextField(
        controller: controller,
        type: keyboardType,
        isReadOnly: true,
        verticalPadding: 0,
        // Remove vertical padding wrapper
        contentPadding: const EdgeInsets.symmetric(
          horizontal: HtmlContentHelper.inputFieldHorizontalPadding,
          vertical: 10, // Reduced vertical padding for smaller height
        ),
        hintColor: context.color.outlineVariant.withValues(alpha: .8),
        hintSize: FontSizes.f12,
        textStyle: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        hint: hint,
      ),
    );
  }

  /// Builds a read-only date input field widget for viewing date values.
  // Widget _dateInput({
  //   required String id,
  //   required dynamic field,
  //   required TextEditingController controller,
  //   required String hint,
  //   required BuildContext context,
  // }) {
  //   return ConstrainedBox(
  //     constraints: const BoxConstraints(
  //       minWidth: HtmlContentHelper.inputFieldMinWidth,
  //       maxWidth: HtmlContentHelper.inputFieldMaxWidth,
  //       maxHeight: 40, // Limit height to fit table cells
  //     ),
  //     child: CustomTextField(
  //       controller: controller,
  //       isReadOnly: true,
  //       verticalPadding: 0,
  //       // Remove vertical padding wrapper
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: HtmlContentHelper.inputFieldHorizontalPadding,
  //         vertical: 6, // Reduced vertical padding for smaller height
  //       ),
  //       hint: hint,
  //       hintStyle: context.textTheme.labelSmall?.copyWith(
  //         color: context.color.outlineVariant,
  //         fontSize: FontSizes.f10,
  //       ),
  //       textStyle: context.textTheme.labelSmall?.copyWith(
  //         fontSize: FontSizes.f10,
  //       ),
  //       suffixIcon: Icons.calendar_month,
  //     ),
  //   );
  // }

  // -------------------------
  // CSS and background color helpers
  // -------------------------

  /// Scans the element tree to determine if any background color is defined.
  /// Checks both 'bgcolor' attributes and CSS 'background-color'/'background' styles.
  // bool _hasAnyBackground(dom.Element root) {
  //   bool found = false;
  //
  //   void scan(dom.Element el) {
  //     if (found) return;
  //
  //     // bgcolor attribute (old HTML)
  //     final bgAttr = el.attributes['bgcolor'];
  //     if (bgAttr != null && bgAttr.trim().isNotEmpty) {
  //       found = true;
  //       return;
  //     }
  //
  //     final style = el.attributes['style'] ?? '';
  //     final bg = _css(style, 'background-color') ?? _css(style, 'background');
  //     if (bg != null && bg.trim().isNotEmpty) {
  //       found = true;
  //       return;
  //     }
  //
  //     for (final c in el.children) {
  //       scan(c);
  //       if (found) return;
  //     }
  //   }
  //
  //   scan(root);
  //   return found;
  // }

  /// Extracts the background color from an HTML element.
  /// Checks 'bgcolor' attribute first, then CSS 'background-color' and 'background' styles.
  Color? _elementBg(dom.Element el) {
    final bgAttr = el.attributes['bgcolor'];
    if (bgAttr != null) {
      final c = _parseCssColor(bgAttr);
      if (c != null) return c;
    }

    final style = el.attributes['style'] ?? '';
    final bg1 = _css(style, 'background-color');
    final bg2 = _css(style, 'background');
    return _parseCssColor(bg1) ?? _parseCssColor(bg2);
  }

  /// Parses a CSS style string and extracts the value for a given property key.
  String? _css(String style, String key) {
    final parts = style.split(';');
    for (final p in parts) {
      final idx = p.indexOf(':');
      if (idx == -1) continue;
      final k = p.substring(0, idx).trim().toLowerCase();
      final v = p.substring(idx + 1).trim();
      if (k == key.toLowerCase()) return v;
    }
    return null;
  }

  /// Extracts padding from an HTML element's style attribute.
  /// Returns EdgeInsets.zero if no padding is found in the response.
  EdgeInsets _elementPadding(dom.Element el) {
    final style = el.attributes['style'] ?? '';
    if (style.isEmpty) return EdgeInsets.zero;

    // Try to extract padding from style
    final padding = _css(style, 'padding');
    if (padding == null || padding.isEmpty) return EdgeInsets.zero;

    // Parse padding value (simple implementation for common cases)
    // Supports: "10px", "10px 20px", "10px 20px 30px 40px"
    final paddingValues = padding
        .split(RegExp(r'\s+'))
        .map((v) => v.replaceAll(RegExp(r'[^\d.]'), ''))
        .where((v) => v.isNotEmpty)
        .map((v) => double.tryParse(v) ?? 0.0)
        .toList();

    if (paddingValues.isEmpty) return EdgeInsets.zero;

    if (paddingValues.length == 1) {
      // All sides same
      final value = paddingValues[0];
      return EdgeInsets.all(value);
    } else if (paddingValues.length == 2) {
      // Vertical and horizontal
      return EdgeInsets.symmetric(
        vertical: paddingValues[0],
        horizontal: paddingValues[1],
      );
    } else if (paddingValues.length == 4) {
      // Top, right, bottom, left
      return EdgeInsets.only(
        top: paddingValues[0],
        right: paddingValues[1],
        bottom: paddingValues[2],
        left: paddingValues[3],
      );
    }

    return EdgeInsets.zero;
  }

  /// Extracts border from an HTML table element's style or border attribute.
  /// Always returns only vertical borders (no horizontal borders).
  /// Returns null if no border is found in the response.
  /// Only uses colors from the response.
  TableBorder? _elementBorder(dom.Element table) {
    // Check both style attribute and border attribute
    final style = table.attributes['style'] ?? '';
    final borderAttr = table.attributes['border'];

    double? width;
    Color? color;

    // First, try to get border from style attribute
    if (style.isNotEmpty) {
      final border = _css(style, 'border');
      if (border != null && border.isNotEmpty) {
        // Parse combined border value (e.g., "1px solid #ccc")
        final borderParts = border.split(RegExp(r'\s+'));
        for (final part in borderParts) {
          if (part.contains('px') ||
              part.contains('pt') ||
              RegExp(r'^\d+$').hasMatch(part)) {
            width =
                double.tryParse(part.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
          } else if (part.startsWith('#') ||
              part.startsWith('rgb') ||
              part.startsWith('rgba')) {
            color = _parseCssColor(part);
          }
        }
      } else {
        // Check for border-width, border-color separately
        final borderWidth = _css(style, 'border-width');
        final borderColor = _css(style, 'border-color');

        if (borderWidth != null) {
          width =
              double.tryParse(borderWidth.replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0;
        }
        if (borderColor != null) {
          color = _parseCssColor(borderColor);
        }
      }
    }

    // If no border found in style, check border attribute (e.g., border="1")
    if (width == null && borderAttr != null && borderAttr.isNotEmpty) {
      width = double.tryParse(borderAttr) ?? 1.0;
      // If border attribute exists but no color in style, try to get color from CSS
      // If still no color, we can't show borders (user wants only colors from response)
      if (color == null) {
        // Check if there's a default border color we can infer
        // But per requirements, we only use colors from response, so return null
        return null;
      }
    }

    // Only create border if both width and color are found
    if (width == null || width <= 0 || color == null) return null;

    // Always return only vertical borders (no horizontal borders)
    // This ensures horizontal separators are never shown, only vertical ones
    return TableBorder(
      left: BorderSide(color: color, width: width),
      right: BorderSide(color: color, width: width),
      top: BorderSide.none,
      bottom: BorderSide.none,
      horizontalInside: BorderSide.none,
      // No horizontal lines between rows
      verticalInside: BorderSide(
        color: color,
        width: width,
      ), // Vertical lines between columns
    );
  }

  /// Parses a CSS color string and converts it to a Flutter Color.
  /// Supports hex (#RRGGBB, #AARRGGBB), rgb(), and rgba() formats.
  /// If "background:" contains multiple tokens, keeps the first useful color token.
  /// Example: "rgba(0,0,0,0.1) url(...)" -> keeps rgba(...)
  /// Example: "#fff center" -> keeps #fff
  /// Returns null for transparent/none (no color from code).
  Color? _parseCssColor(String? css) {
    if (css == null) return null;
    var s = css.trim().toLowerCase();

    if (s.isEmpty || s == 'transparent' || s == 'none') {
      return null; // No color from code, return null
    }

    // If the string already starts with a color format, use it as-is
    // Otherwise, extract the first token (handles cases like "#fff center")
    if (!s.startsWith('rgb(') && !s.startsWith('rgba(') && !s.startsWith('#')) {
      s = s.split(RegExp(r'\s+')).first;
    }

    // Parse hex colors: #RRGGBB or #AARRGGBB
    if (s.startsWith('#')) {
      final hex = s.substring(1);
      if (hex.length == 6) {
        // 6-digit hex: add alpha channel
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 8) {
        // 8-digit hex: includes alpha channel
        return Color(int.parse(hex, radix: 16));
      }
    }

    // Parse rgb(r,g,b) format
    final rgb = RegExp(
      r'rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)',
    ).firstMatch(s);
    if (rgb != null) {
      return Color.fromARGB(
        255, // Full opacity
        int.parse(rgb.group(1)!),
        int.parse(rgb.group(2)!),
        int.parse(rgb.group(3)!),
      );
    }

    // Parse rgba(r,g,b,a) format
    final rgba = RegExp(
      r'rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([0-9.]+)\s*\)',
    ).firstMatch(s);
    if (rgba != null) {
      // Convert alpha from 0.0-1.0 range to 0-255
      final a = (double.parse(rgba.group(4)!) * 255).round().clamp(0, 255);
      return Color.fromARGB(
        a,
        int.parse(rgba.group(1)!),
        int.parse(rgba.group(2)!),
        int.parse(rgba.group(3)!),
      );
    }

    return null;
  }
}
