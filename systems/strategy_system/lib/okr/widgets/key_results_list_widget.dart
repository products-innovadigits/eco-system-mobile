import 'package:core_system/core/helpers/font_sizes.dart';

import '../../shared/strategy_exports.dart';

class KeyResultsListWidget extends StatelessWidget {
  final List<IndicatorModel> keyResults;

  const KeyResultsListWidget({super.key, required this.keyResults});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: (keyResults).map((kr) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: context.color.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.color.secondary.withValues(alpha: 0.1),
                        ),
                        child: Images(
                          image: Assets.svgs.target.path,
                          width: 14.w,
                        ),
                      ),
                      8.sw,
                      Expanded(
                        child: Text(
                          kr.title ?? '',
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Styles.statusColors(
                    kr.status ?? '',
                    isLineProgress: true,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    '(${kr.percentage}%)',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Styles.statusColors(kr.status ?? '' , isLineProgress: true),
                      fontSize: FontSizes.f10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
