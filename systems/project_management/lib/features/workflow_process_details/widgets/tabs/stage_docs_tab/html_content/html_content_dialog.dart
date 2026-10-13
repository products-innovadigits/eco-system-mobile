import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/editable_html_renderer.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/html_content_helper.dart';

/// Dialog that displays HTML content with read-only fields.
/// Allows users to view document fields and download the PDF.
class HtmlContentDialog extends StatelessWidget {
  /// The document containing HTML content and field definitions
  final StageDocument document;

  const HtmlContentDialog({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final htmlContent = document.data?.content ?? '';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: HtmlContentHelper.dialogInsetPadding,
      // Fill the space the dialog allows without depending on MediaQuery,
      // which would rebuild the dialog on every screen-metrics change.
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(
            HtmlContentHelper.dialogBorderRadius,
          ),
        ),
        child: Column(
          children: [
            _DialogHeader(title: document.documentTitle),
            const Divider(height: 1),
            Expanded(
              child: htmlContent.isEmpty
                  ? const EmptyContainer()
                  : Padding(
                      padding: const EdgeInsets.all(
                        HtmlContentHelper.dialogPadding,
                      ),
                      child: SingleChildScrollView(
                        child: EditableHtmlRenderer(
                          htmlContent: htmlContent,
                          fields: document.data?.fields ?? const {},
                        ),
                      ),
                    ),
            ),
            _DownloadButton(exportUrl: document.exportUrl ?? ''),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String? title;

  const _DialogHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(HtmlContentHelper.dialogPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? allTranslations.text(LocaleKeys.document_content),
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
}

class _DownloadButton extends StatelessWidget {
  final String exportUrl;

  const _DownloadButton({required this.exportUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(HtmlContentHelper.dialogPadding),
      child: CustomBtn(
        text: allTranslations.text(LocaleKeys.download),
        active: exportUrl.isNotEmpty,
        onPressed: () => LauncherHelper.downloadFiles(
          filePath: '',
          fullLink: exportUrl,
          context: context,
        ),
      ),
    );
  }
}
