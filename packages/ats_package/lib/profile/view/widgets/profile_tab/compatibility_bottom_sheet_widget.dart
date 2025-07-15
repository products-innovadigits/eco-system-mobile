import 'package:ats_package/profile/view/widgets/compatibility_percentage_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CompatibilityBottomSheetWidget extends StatelessWidget {
  const CompatibilityBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(
          title: allTranslations.text(LocaleKeys.compatibility),
        ),
        24.sh,
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Row(
                  children: [
                    Images(image: Assets.svgs.tickCircle.path),
                    8.sw,
                    Text('البحث عن تجربة المستخدم',
                        style: AppTextStyles.w400.copyWith(fontSize: 12))
                  ],
                ),
            separatorBuilder: (context, index) => 16.sh,
            itemCount: 6),
        24.sh,
        CompatibilityPercentageWidget(
            title: allTranslations.text(LocaleKeys.keyword_matching),
            percentage: 80),
      ],
    );
  }
}
