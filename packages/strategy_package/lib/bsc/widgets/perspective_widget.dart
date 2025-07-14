import 'package:core_package/core/utility/export.dart';

class PerspectiveWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const PerspectiveWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: context.color.secondary.withValues(alpha: 0.07
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.color.secondary.withValues(alpha: 0.1),
              ),
              child: Images(image: Assets.svgs.focusPoint.path),
            ),
            Text(
              title,
              style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
