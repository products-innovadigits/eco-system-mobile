import '../../../core/utility/pms_exports.dart';

/// Compact placeholder shown inside a home card body when its request
/// failed or came back empty, sized to fit within the card instead of
/// the full-screen [EmptyContainer]/[ErrorContainer].
class HomeCardStateMessage extends StatelessWidget {
  final String message;
  final bool isError;
  final double height;

  const HomeCardStateMessage({
    super.key,
    required this.message,
    this.isError = false,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Images(
              image: isError ? Assets.svgs.error.path : Assets.svgs.emptyBox.path,
              height: 32.h,
              width: 32.w,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.outlineVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
