import 'package:ats_package/profile/view/widgets/profile_tab/compatibility_bottom_sheet_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';


class CandidateCompatibilitySection extends StatelessWidget {
  const CandidateCompatibilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          PopUpHelper.showBottomSheet(child: CompatibilityBottomSheetWidget()),
      child: Container(
        width: context.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Styles.BORDER)),
        child: Row(
          children: [
            PercentageAvatar(
              avatarPath: Assets.images.avatar.path,
              percentage: '80',
              avatarSize: 32.w,
              percentageMargin: 4.w,
              percentageRadius: 2.w,
              percentageTextStyle: AppTextStyles.w600
                  .copyWith(color: Styles.TEXT_BLUE_DARK_COLOR, fontSize: 6),
            ),
            12.sw,
            Text(
              'ما مدي التوافق بين هشام وهذة الوظيفة؟',
              style: AppTextStyles.w400
                  .copyWith(color: Styles.TEXT_COLOR, fontSize: 10),
            ),
            const Spacer(),
            Images(image: Assets.svgs.arrowLeft.path),
          ],
        ),
      ),
    );
  }
}
