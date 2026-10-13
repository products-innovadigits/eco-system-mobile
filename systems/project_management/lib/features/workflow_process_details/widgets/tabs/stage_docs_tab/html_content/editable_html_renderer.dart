import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/html_content_helper.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/html_css_parser.dart';

/// Renders HTML content with read-only form fields for viewing.
/// Supports paragraphs, tables and line breaks. Fields are identified by
/// `data-id` attributes on `builder-shortcode-container` elements.
class EditableHtmlRenderer extends StatefulWidget {
  /// The HTML content to render
  final String htmlContent;

  /// Field definitions mapped by field ID (same as data-id in HTML).
  final Map<String, dynamic> fields;

  const EditableHtmlRenderer({
    super.key,
    required this.htmlContent,
    required this.fields,
  });

  @override
  State<EditableHtmlRenderer> createState() => _EditableHtmlRendererState();
}

class _EditableHtmlRendererState extends State<EditableHtmlRenderer> {
  late List<dom.Node> _nodes;
  final Map<String, TextEditingController> _controllers = {};

  /// Built widget tree, reused across rebuilds. Cleared when the content,
  /// the fields or an inherited dependency (e.g. the theme) changes.
  Widget? _content;

  @override
  void initState() {
    super.initState();
    _parseHtml();
    _createControllers();
  }

  @override
  void didUpdateWidget(EditableHtmlRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.htmlContent != oldWidget.htmlContent) {
      _parseHtml();
      _content = null;
    }
    if (!identical(widget.fields, oldWidget.fields)) {
      _disposeControllers();
      _createControllers();
      _content = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _content = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _parseHtml() {
    _nodes = html_parser.parseFragment(widget.htmlContent).nodes;
  }

  void _createControllers() {
    widget.fields.forEach((id, field) {
      _controllers[id] = TextEditingController(
        text: HtmlContentHelper.readFieldValue(field),
      );
    });
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _content ??= Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildBlocks(_nodes),
    );
  }

  // -------------------------
  // Block-level builders
  // -------------------------

  /// Builds block-level widgets (paragraphs, tables, line breaks).
  List<Widget> _buildBlocks(List<dom.Node> nodes) {
    final out = <Widget>[];

    for (final node in nodes) {
      if (node is dom.Text) {
        final text = HtmlContentHelper.cleanText(node.text).trim();
        if (text.isNotEmpty) {
          out.add(Text(text, style: context.textTheme.bodyMedium));
        }
        continue;
      }

      if (node is! dom.Element) continue;

      switch (node.localName) {
        case 'p':
          out
            ..add(_buildParagraph(node))
            ..add(
              const SizedBox(height: HtmlContentHelper.paragraphBottomSpacing),
            );
        case 'table':
          out
            ..add(_buildTable(node))
            ..add(const SizedBox(height: HtmlContentHelper.tableBottomSpacing));
        case 'br':
          out.add(const SizedBox(height: HtmlContentHelper.lineBreakSpacing));
        default:
          out.addAll(_buildBlocks(node.nodes));
      }
    }

    return out;
  }

  Widget _buildParagraph(dom.Element p) {
    final parts = _buildInline(p.nodes);
    if (parts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: HtmlContentHelper.inlineSpacing,
      runSpacing: HtmlContentHelper.paragraphRunSpacing,
      children: parts,
    );
  }

  /// Builds inline widgets (text, fields, line breaks); other inline elements
  /// (spans, links, strong, ...) are flattened into their children.
  List<Widget> _buildInline(List<dom.Node> nodes) {
    final out = <Widget>[];

    for (final node in nodes) {
      if (node is dom.Text) {
        final text = HtmlContentHelper.cleanText(node.text);
        if (text.trim().isNotEmpty) {
          out.add(Text(text, style: context.textTheme.bodyMedium));
        }
        continue;
      }

      if (node is! dom.Element) continue;

      final fieldId = node.attributes['data-id'];
      final isField =
          node.classes.contains('builder-shortcode-container') &&
          fieldId != null &&
          widget.fields.containsKey(fieldId);

      if (isField) {
        out.add(
          _ReadOnlyField(
            controller: _controllers[fieldId]!,
            hint: HtmlContentHelper.readFieldPlaceholder(
              widget.fields[fieldId],
            ),
          ),
        );
      } else if (node.localName == 'br') {
        out.add(const SizedBox(width: double.infinity));
      } else {
        out.addAll(_buildInline(node.nodes));
      }
    }

    return out;
  }

  // -------------------------
  // Table rendering
  // -------------------------

  /// Builds a DataTable from an HTML `<table>`, using only styling that
  /// comes from the HTML response. The first row is used as the header.
  Widget _buildTable(dom.Element table) {
    final rows = table.getElementsByTagName('tr');
    if (rows.isEmpty) return const SizedBox.shrink();

    final headerCells = _cellsOf(rows.first);
    // DataTable requires at least one column.
    if (headerCells.isEmpty) return const SizedBox.shrink();

    final tableBg = HtmlCssParser.background(table);
    final headerBg = HtmlCssParser.background(rows.first) ?? tableBg;
    final headerStyle = context.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final columns = [
      for (final cell in headerCells)
        DataColumn(label: Text(_headerText(cell), style: headerStyle)),
    ];

    final dataRows = [
      for (final row in rows.skip(1))
        _buildTableRow(row, headerCells.length, tableBg),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        horizontalMargin: 8,
        // Grow rows to fit fields and wrapped text instead of clipping them.
        dataRowMaxHeight: double.infinity,
        headingRowColor: WidgetStateProperty.all(
          headerBg ?? Colors.transparent,
        ),
        dataRowColor: WidgetStateProperty.all(Colors.transparent),
        border: HtmlCssParser.tableBorder(table) ?? const TableBorder(),
        columns: columns,
        rows: dataRows,
      ),
    );
  }

  DataRow _buildTableRow(dom.Element row, int colCount, Color? tableBg) {
    final rowBg = HtmlCssParser.background(row) ?? tableBg;
    final cellEls = _cellsOf(row);

    return DataRow(
      color: WidgetStateProperty.all(rowBg ?? Colors.transparent),
      cells: [
        // Pad short rows so every row matches the header's column count.
        for (var i = 0; i < colCount; i++)
          DataCell(
            _buildTableCell(i < cellEls.length ? cellEls[i] : null, rowBg),
          ),
      ],
    );
  }

  Widget _buildTableCell(dom.Element? cellEl, Color? rowBg) {
    if (cellEl == null) {
      return rowBg == null
          ? const SizedBox.shrink()
          : ColoredBox(color: rowBg, child: const SizedBox.shrink());
    }

    final cellBg = HtmlCssParser.background(cellEl) ?? rowBg;
    final cellPadding = HtmlCssParser.padding(cellEl);

    final content = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: HtmlContentHelper.tableCellMinWidth,
      ),
      child: Wrap(
        spacing: HtmlContentHelper.inlineSpacing,
        runSpacing: HtmlContentHelper.paragraphRunSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: _buildInline(cellEl.nodes),
      ),
    );

    // Only wrap when the response provides a background or padding.
    if (cellBg == null && cellPadding == EdgeInsets.zero) return content;
    return Container(color: cellBg, padding: cellPadding, child: content);
  }

  static List<dom.Element> _cellsOf(dom.Element row) => row.children
      .where((c) => c.localName == 'td' || c.localName == 'th')
      .toList();

  static String _headerText(dom.Element cell) {
    final text = HtmlContentHelper.cleanText(cell.text).trim();
    return text.isEmpty ? ' ' : text;
  }
}

/// Read-only text input showing a field's value from the response.
class _ReadOnlyField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _ReadOnlyField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: HtmlContentHelper.inputFieldMinWidth,
        maxWidth: HtmlContentHelper.inputFieldMaxWidth,
      ),
      child: CustomTextField(
        controller: controller,
        isReadOnly: true,
        verticalPadding: 0,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: HtmlContentHelper.inputFieldHorizontalPadding,
          vertical: HtmlContentHelper.inputFieldVerticalPadding,
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
}
