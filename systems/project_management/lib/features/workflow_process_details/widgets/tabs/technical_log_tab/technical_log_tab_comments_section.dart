import '../../../../../core/utility/project_management_exports.dart';

class TechnicalLogTabCommentsSection extends StatelessWidget {
  final List<StepCommentModel> comments;

  const TechnicalLogTabCommentsSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: context.color.surfaceContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: context.color.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            allTranslations.text(LocaleKeys.no_comments_available),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...comments.map(
          (comment) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _CommentItem(comment: comment),
          ),
        ),
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  final StepCommentModel comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.color.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Images(image: Assets.svgs.comment.path),
              SizedBox(width: 4.w),
              Text(
                comment.createdBy ?? allTranslations.text(LocaleKeys.unknown),
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                _formatCommentTime(comment.createdAt),
                textDirection: TextDirection.ltr,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.secondary,
                  fontSize: FontSizes.f10,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            comment.text ?? '',
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: FontSizes.f10,
            ),
          ),
          if (comment.attachmentUrls.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final url in comment.attachmentUrls)
                  _AttachmentItem(url: url),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatCommentTime(String? createdAt) {
    if (createdAt == null) return "0000-00-00 10:00 AM";
    try {
      // Normalize potential high‑precision fractional seconds to max 6 digits
      String normalized = createdAt;
      final tzMatchIndex = normalized.indexOf(
        RegExp(r'Z|[+-]\d{2}:\d{2}'),
      ); // timezone start
      if (tzMatchIndex != -1) {
        final main = normalized.substring(0, tzMatchIndex);
        final tz = normalized.substring(tzMatchIndex);
        final dotIndex = main.indexOf('.');
        if (dotIndex != -1) {
          var frac = main.substring(dotIndex + 1);
          if (frac.length > 6) {
            frac = frac.substring(0, 6);
          }
          normalized = '${main.substring(0, dotIndex + 1)}$frac$tz';
        }
      }

      final utcDateTime = DateTime.parse(normalized);
      final localDateTime = utcDateTime.toLocal();

      final year = localDateTime.year.toString().padLeft(4, '0');
      final month = localDateTime.month.toString().padLeft(2, '0');
      final day = localDateTime.day.toString().padLeft(2, '0');

      final hour = localDateTime.hour;
      final minute = localDateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return "$day/$month/$year - $displayHour:$minute $period";
    } catch (e) {
      return "0000-00-00 - 10:00 AM";
    }
  }
}

class _AttachmentItem extends StatelessWidget {
  final String url;

  const _AttachmentItem({required this.url});

  /// The file name out of the URL, without the upload timestamp the server
  /// prefixes it with (`1791890025 - report.pdf` -> `report.pdf`).
  static String fileName(String url) {
    final segments = Uri.tryParse(url)?.pathSegments ?? const <String>[];
    final name = segments.isNotEmpty ? segments.last : url;
    return name.replaceFirst(RegExp(r'^\d+ - '), '');
  }

  static IconData _icon(String name) {
    final dot = name.lastIndexOf('.');
    final extension = dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
    return switch (extension) {
      'pdf' => Icons.picture_as_pdf,
      'doc' || 'docx' || 'txt' => Icons.description,
      'jpg' || 'jpeg' || 'png' || 'gif' => Icons.image,
      'xls' || 'xlsx' => Icons.table_chart,
      'ppt' || 'pptx' => Icons.slideshow,
      _ => Icons.attach_file,
    };
  }

  @override
  Widget build(BuildContext context) {
    final name = fileName(url);
    final color = context.color.secondary;

    return InkWell(
      onTap: () =>
          LauncherHelper.downloadFiles(filePath: url, context: context),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon(name), size: 16, color: color),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: context.textTheme.bodySmall?.copyWith(color: color),
              ),
            ),
            SizedBox(width: 6.w),
            Images(image: Assets.svgs.download.path),
          ],
        ),
      ),
    );
  }
}
