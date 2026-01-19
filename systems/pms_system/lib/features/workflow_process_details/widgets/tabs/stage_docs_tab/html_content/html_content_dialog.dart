import 'package:pms_system/features/workflow_process_details/model/stage_doc_model.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/editable_html_renderer.dart';
import 'package:pms_system/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/html_content_helper.dart';

import '../../../../../../core/utility/pms_exports.dart';

/// Dialog that displays HTML content with read-only fields.
/// Allows users to view document fields and download the PDF.
class HtmlContentDialog extends StatefulWidget {
  /// The document containing HTML content and field definitions
  final StageDocument document;

  /// Path to the PDF file for download
  final String pdfFilePath;

  const HtmlContentDialog({
    super.key,
    required this.document,
    required this.pdfFilePath,
  });

  @override
  State<HtmlContentDialog> createState() => _HtmlContentDialogState();
}

class _HtmlContentDialogState extends State<HtmlContentDialog> {
  // -------------------------
  // State
  // -------------------------

  /// Text editing controllers for each field, keyed by field ID
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  /// Initializes text editing controllers for all fields in the document.
  void _initControllers() {
    final fields = widget.document.data?.fields;
    if (fields == null) return;

    fields.forEach((id, field) {
      final value = HtmlContentHelper.readFieldValue(field);
      _controllers[id] = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    // Dispose all text editing controllers to prevent memory leaks
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final htmlContent = widget.document.data?.content ?? '';
    if (htmlContent.isEmpty) {
      return const EmptyContainer();
    }

    final fields = widget.document.data?.fields ?? {};

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: HtmlContentHelper.dialogInsetPadding,
      child: Container(
        width: context.w,
        height: context.h,
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(
            HtmlContentHelper.dialogBorderRadius,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            _buildContent(htmlContent, fields),
            // _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the dialog header with title and close button.
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HtmlContentHelper.dialogPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.document.documentTitle ??
                  allTranslations.text('document_content'),
              style: context.textTheme.titleMedium,
            ),
          ),
          InkWell(
            onTap: () => CustomNavigator.pop(),
            child: Images(image: Assets.svgs.closeSquare.path),
          ),
        ],
      ),
    );
  }

  /// Builds the scrollable content area with read-only HTML renderer.
  Widget _buildContent(String htmlContent, Map<String, dynamic> fields) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(HtmlContentHelper.dialogPadding),
        child: SingleChildScrollView(
          child: EditableHtmlRenderer(
            htmlContent: htmlContent,
            fields: fields,
            controllers: _controllers,
          ),
        ),
      ),
    );
  }

  /// Builds the download button section.
  // Widget _buildDownloadButton() {
  //   return Container(
  //     padding: const EdgeInsets.all(HtmlContentHelper.dialogPadding),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: CustomBtn(
  //             text: allTranslations.text(LocaleKeys.download),
  //             onPressed: () => LauncherHelper.downloadFiles(
  //               filePath: widget.pdfFilePath,
  //               context: context,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
