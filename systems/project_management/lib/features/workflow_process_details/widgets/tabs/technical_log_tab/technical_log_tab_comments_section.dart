import 'package:project_management/core/utility/project_management_exports.dart';

class TechnicalLogTabCommentsSection extends StatelessWidget {
  final List<StepCommentModel> comments;

  const TechnicalLogTabCommentsSection({super.key, required this.comments});

  /// `dd/MM/yyyy - h:mm AM` in local time, or empty when the API sent no
  /// readable time.
  @visibleForTesting
  static String formatCommentTime(String? createdAt) {
    final time = DateTime.tryParse(createdAt ?? '')?.toLocal();
    if (time == null) return '';

    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${twoDigits(time.day)}/${twoDigits(time.month)}/${time.year}'
        ' - $hour:${twoDigits(time.minute)} $period';
  }

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
        for (final comment in comments)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _CommentItem(comment: comment),
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
                TechnicalLogTabCommentsSection.formatCommentTime(
                  comment.createdAt,
                ),
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
      // Uploads never change, so an earlier download is reopened.
      onTap: () => FileOpenerHelper.downloadAndOpen(
        context: context,
        url: url,
        reuseDownloaded: true,
      ),
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
