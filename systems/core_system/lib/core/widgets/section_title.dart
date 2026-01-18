import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.withView = false,
    this.subText,
    this.onViewTap,
    this.icon,
    this.moreBtnTxt,
  });

  final String title;
  final String? subText;
  final String? moreBtnTxt;
  final String? icon;
  final bool withView;
  final Function()? onViewTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon != null) ...[Images(image: icon!), SizedBox(width: 16.w)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.w700.copyWith(
                    fontSize: FontSizes.f14,
                    color: context.color.onSurface,
                  ),
                ),
                if (subText != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      subText!,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 11,
                        color: context.color.outlineVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (withView)
            InkWell(
              onTap: onViewTap,
              child: Row(
                children: [
                  Text(
                    moreBtnTxt ?? allTranslations.text(LocaleKeys.go_to_system),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.color.secondary,
                    ),
                  ),
                  // Icon(Icons.arrow_forward_rounded,
                  //     size: 16, color: context.color.primary)
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SectionTitleShimmer extends StatelessWidget {
  const SectionTitleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [CustomShimmerText(width: 100), CustomShimmerText(width: 70)],
      ),
    );
  }
}
