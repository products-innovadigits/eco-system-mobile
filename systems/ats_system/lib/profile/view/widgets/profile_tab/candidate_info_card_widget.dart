import 'package:core_system/core/utility/export.dart';

class CandidateInfoCardWidget extends StatelessWidget {
  final bool? isPrimaryColor;
  final String title;
  final String value;

  const CandidateInfoCardWidget({
    super.key,
    this.isPrimaryColor = true,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: (isPrimaryColor ?? true)
            ? context.color.primary.withValues(alpha: 0.1)
            : context.color.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                value,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.color.primary,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 10,
                  color: context.color.outlineVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
