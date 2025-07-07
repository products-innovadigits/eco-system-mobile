import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 30.h),
      Text(
        allTranslations.text("login_header"),
        style: AppTextStyles.w700.copyWith(
          color: context.color.onSurface,
          fontSize: FontSizes.f30,
        ),
      ),
      SizedBox(height: 12.h),
      Text(
        allTranslations.text("login_sub_header"),
        style: AppTextStyles.w400.copyWith(
          color: context.color.outline,
          fontSize: FontSizes.f14,
        ),
      ),
    ]);
  }
}
