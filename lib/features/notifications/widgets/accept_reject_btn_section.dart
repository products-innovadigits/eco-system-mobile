import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class AcceptRejectBtnSection extends StatelessWidget {
  const AcceptRejectBtnSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        children: [
          Expanded(
            child: CustomBtn(
              text: allTranslations.text(LocaleKeys.accept),
            ),
          ),
          6.sw,
          Expanded(
            child: CustomBtn(
              text: allTranslations.text(LocaleKeys.reject),
              color: context.color.surfaceContainer,
              borderColor: context.color.primary,
              textColor: context.color.primary,
              fontSize: FontSizes.f12,
            ),
          ),
        ],
      ),
    );
  }
}
