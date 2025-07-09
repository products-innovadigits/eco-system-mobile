import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CandidateCardWidget extends StatelessWidget {
  const CandidateCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //TODO pass the candidate id
      onTap: () => CustomNavigator.push(Routes.PROFILE,
          arguments: ProfileViewArgs(isTalent: false, candidateId: 500)),
      child: Container(
        width: context.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.color.outline)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PercentageAvatar(
                  avatarPath: Assets.images.avatar.path,
                  percentage: '80',
                  avatarSize: 42.w,
                  percentageMargin: 8.w,
                  percentageRadius: 2.w,
                  percentageTextStyle: context.textTheme.labelSmall
                      ?.copyWith(fontSize: 6),
                ),
                8.sw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هشام منصور',
                      style: context.textTheme.labelSmall
                    ),
                    2.sh,
                    Row(
                      children: [
                        Text(
                          'مدير المشروعات . ',
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: context.color.outlineVariant)
                        ),
                        Text('5 من الوظائف',
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: context.color.secondary))
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Images(image: Assets.svgs.arrowLeft.path , color: context.color.outline),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Divider(color: context.color.outline),
            ),
            CandidateDataSection()
          ],
        ),
      ),
    );
  }
}
