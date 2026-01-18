import 'package:ats_system/profile/view/widgets/compatibility_percentage_widget.dart';
import 'package:core_system/core/utility/export.dart';

class CompatibilityBottomSheetWidget extends StatelessWidget {
  const CompatibilityBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(
          title: allTranslations.text(LocaleKeys.compatibility),
        ),
        SizedBox(height: 24.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Row(
            children: [
              Images(image: Assets.svgs.tickCircle.path),
              SizedBox(width: 8.w),
              Text(
                'البحث عن تجربة المستخدم',
                style: AppTextStyles.w400.copyWith(fontSize: 12),
              ),
            ],
          ),
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemCount: 6,
        ),
        SizedBox(height: 24.h),
        CompatibilityPercentageWidget(
          title: allTranslations.text(LocaleKeys.keyword_matching),
          percentage: 80,
        ),
      ],
    );
  }
}
