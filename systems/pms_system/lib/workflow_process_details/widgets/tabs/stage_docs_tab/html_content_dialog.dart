import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../../../shared/pms_exports.dart';

class HtmlContentDialog extends StatelessWidget {
  final StageDocument document;
  final String pdfFilePath;

  const HtmlContentDialog({
    super.key,
    required this.document,
    required this.pdfFilePath,
  });

  @override
  Widget build(BuildContext context) {
    final htmlContent = document.data?.content ?? '';
    if (htmlContent.isEmpty) {
      return const EmptyContainer();
    }

    final bool hasTable = HtmlTableHelper.hasTable(htmlContent);
    final List<List<String>> parsedContent = hasTable
        ? HtmlTableHelper.parseHtmlTable(htmlContent)
        : [];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: context.w,
        height: context.h,
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header with padding
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      document.documentTitle ??
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
            ),
            Divider(height: 1),
            // Content with padding
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: hasTable && parsedContent.isNotEmpty
                      ? _buildTableFromData(parsedContent, context)
                      : Text(
                          HtmlTableHelper.getPlainText(htmlContent),
                          style: context.textTheme.bodyMedium,
                        ),
                ),
              ),
            ),
            // Download button at bottom
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomBtn(
                      text: allTranslations.text(LocaleKeys.download),
                      onPressed: () =>
                          _downloadHtmlContent(context, pdfFilePath),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadHtmlContent(
    BuildContext context,
    String pdfFilePath,
  ) async {
    try {
      log('PdfFilePath :: $pdfFilePath');
      await UrlLauncher.launchUrl(
        Uri.parse('https://194.163.168.5:447$pdfFilePath'),
      );
      AppCore.successToastMessage(
        allTranslations.text(LocaleKeys.file_downloaded_successfully),
      );
    } catch (e) {
      AppCore.errorToastMessage(allTranslations.text('download_failed'));
    }
  }

  Widget _buildTableFromData(
    List<List<String>> tableData,
    BuildContext context,
  ) {
    if (tableData.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 8,
        horizontalMargin: 8,
        // Customize table colors
        headingRowColor: WidgetStateProperty.all(
          context.color.secondary.withValues(alpha: 0.1),
        ),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          // Alternate row colors
          if (states.contains(WidgetState.selected)) {
            return context.color.secondary.withValues(alpha: 0.2);
          }
          return null; // Use default color
        }),
        columns: tableData.first
            .map(
              (header) => DataColumn(
                label: Text(
                  header,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.color.onSurface, // Force text color
                  ),
                ),
              ),
            )
            .toList(),
        rows: tableData
            .skip(1)
            .map(
              (row) => DataRow(
                cells: row
                    .map(
                      (cell) => DataCell(
                        Text(
                          cell,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.color.onSurface, // Force text color
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
