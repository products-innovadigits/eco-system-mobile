import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class CandidateCardHeaderSection extends StatelessWidget {
  const CandidateCardHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PercentageAvatar(
          avatarPath: Assets.images.avatar.path,
          percentage: '80',
          avatarSize: 32.w,
          percentageMargin: 4.w,
          percentageRadius: 2.w,
          percentageTextStyle: AppTextStyles.w600.copyWith(
            color: Styles.textBlueDarkColor,
            fontSize: 6,
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هشام منصور', style: context.textTheme.labelSmall),
            SizedBox(height: 2.h),
            Row(
              children: [
                Text(
                  'مدير المشروعات . ',
                  style: AppTextStyles.w400.copyWith(
                    color: Styles.subTextDarkColor,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '5 من الوظائف',
                  style: AppTextStyles.w400.copyWith(
                    color: context.color.primary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Images(image: Assets.svgs.arrowLeft.path),
      ],
    );
  }
}
