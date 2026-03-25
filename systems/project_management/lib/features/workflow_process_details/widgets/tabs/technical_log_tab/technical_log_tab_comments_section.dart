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
          if (comment.filePath != null) ...[
            SizedBox(height: 12.h),
            _AttachmentItem(attachmentFilePath: comment.filePath!),
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
  final String attachmentFilePath;

  const _AttachmentItem({required this.attachmentFilePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        LauncherHelper.downloadFiles(
          filePath: attachmentFilePath,
          // fullLink: attachmentFilePath,
          context: context,
        );
      },
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
            Images(image: Assets.svgs.download.path),
            SizedBox(width: 6.w),
            Text(
              allTranslations.text(LocaleKeys.attachments_count),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
