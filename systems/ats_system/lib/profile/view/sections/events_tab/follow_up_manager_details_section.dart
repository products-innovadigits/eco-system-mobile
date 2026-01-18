import 'package:core_system/core/utility/export.dart';

class FollowUpManagerDetailsSection extends StatelessWidget {
  const FollowUpManagerDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: context.color.outline, width: 2),
            image: DecorationImage(
              image: AssetImage(Assets.images.avatar.path),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اسلام محمد',
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Text(
                  '1 August 2023 . ',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: context.color.outlineVariant,
                  ),
                ),
                Text(
                  '12:00 Am',
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: context.color.outlineVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
