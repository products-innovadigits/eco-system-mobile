
import '../../../../../core/utility/project_management_exports.dart';

class TechnicalLogTabAttachmentsSection extends StatelessWidget {
  final List<AttachmentModel> attachments;
  const TechnicalLogTabAttachmentsSection({
    super.key,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: attachments
          .map((attachment) => _AttachmentItem(attachment: attachment))
          .toList(),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final AttachmentModel attachment;

  const _AttachmentItem({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFileIcon(attachment.slice?.type),
            size: 16,
            color: context.color.secondary,
          ),
          SizedBox(width: 4.w),
          Text(
            attachment.slice?.title ??
                allTranslations.text(LocaleKeys.attachments_count),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.color.secondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        return Icons.attach_file;
    }
  }
}
