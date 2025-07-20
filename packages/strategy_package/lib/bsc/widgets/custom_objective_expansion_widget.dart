import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';

class CustomObjectiveExpansionWidget extends StatelessWidget {
  final String title;
  final List<IndicatorModel> indicators;
  final String indicatorIcon;
  // final bool initiallyExpanded;

  const CustomObjectiveExpansionWidget({
    super.key,
    required this.title,
    required this.indicators,
    required this.indicatorIcon,
    // required this.initiallyExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: context.textTheme.labelSmall),
      leading: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.color.secondary.withValues(alpha: 0.1),
        ),
        child: Images(image: Assets.svgs.rocket.path),
      ),
      visualDensity: VisualDensity.compact,
      tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
      expansionAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.color.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.color.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      iconColor: context.color.secondary,
      collapsedIconColor: context.color.outlineVariant,
      collapsedTextColor: context.color.onSurface,
      // initiallyExpanded: initiallyExpanded,
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(start: 36.w, end: 16.w),
          child: Column(
            children: (indicators).map((indicator) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.color.outlineVariant.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.color.secondary.withValues(alpha: 0.1),
                      ),
                      child: Images(image: indicatorIcon),
                    ),
                    8.sw,
                    Text(
                      indicator.title ?? '',
                      style: context.textTheme.labelSmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
