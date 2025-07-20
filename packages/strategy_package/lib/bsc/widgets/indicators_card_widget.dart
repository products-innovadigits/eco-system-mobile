import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';

class IndicatorsCardWidget extends StatelessWidget {
  final String objectiveTitle;
  final List<IndicatorModel> indicators;
  final VoidCallback onTap;
  final bool isExpanded;
  final String indicatorIcon;

  const IndicatorsCardWidget({
    super.key,
    required this.objectiveTitle,
    required this.indicators,
    required this.onTap,
    required this.isExpanded,
    required this.indicatorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(
          color: context.color.outlineVariant.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.color.secondary.withValues(alpha: 0.1),
                  ),
                  child: Images(image: indicatorIcon, width: 14.w),
                ),
                8.sw,
                Text(objectiveTitle, style: context.textTheme.labelMedium),
                const Spacer(),
                AnimatedExpansionArrowWidget(isExpanded: isExpanded),
              ],
            ),
          ),
          16.sh,
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: EdgeInsetsDirectional.only(start: 24.w),
              child: Column(
                children: (indicators).map((indicator) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 12.h,
                    ),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.color.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.color.secondary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                          child: Images(image: indicatorIcon, width: 14.w),
                        ),
                        8.sw,
                        Expanded(
                          child: Text(
                            indicator.title ?? '',
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }
}
