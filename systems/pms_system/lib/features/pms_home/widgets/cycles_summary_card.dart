import 'package:core_system/core/widgets/main_card_widget.dart';
import 'package:pms_system/core/utility/pms_exports.dart';

class CyclesSummaryCard extends StatelessWidget {
  const CyclesSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(LocaleKeys.cycles_summary),
      moreBtnTxt: allTranslations.text(LocaleKeys.view_all_cycles),
      onViewMoreTap: () {
        CustomNavigator.push(Routes.CYCLES);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CyclesLegend(),
          SizedBox(height: 16.h),
          _CycleProgressItem(
            label: allTranslations.text(LocaleKeys.active_cycles),
            percentage: 82,
            color: LightColor.warning,
          ),
          SizedBox(height: 14.h),
          _CycleProgressItem(
            label: allTranslations.text(LocaleKeys.overdue),
            percentage: 12,
            color: LightColor.error,
          ),
          SizedBox(height: 14.h),
          _CycleProgressItem(
            label: allTranslations.text(LocaleKeys.completed),
            percentage: 100,
            color: LightColor.tertiary,
          ),
        ],
      ),
    );
  }
}

class _CyclesLegend extends StatelessWidget {
  const _CyclesLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _LegendDot(
          label: allTranslations.text(LocaleKeys.active_cycles),
          count: 154,
          color: LightColor.warning,
        ),
        SizedBox(width: 12.w),
        _LegendDot(
          label: allTranslations.text(LocaleKeys.overdue),
          count: 26,
          color: LightColor.error,
        ),
        SizedBox(width: 12.w),
        _LegendDot(
          label: allTranslations.text(LocaleKeys.completed),
          count: 39,
          color: LightColor.tertiary,
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _LegendDot({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          '$label ($count)',
          style: context.textTheme.labelSmall?.copyWith(
            color: context.color.outlineVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _CycleProgressItem extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;

  const _CycleProgressItem({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = percentage.clamp(0, 100);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                height: 22,
                margin: const EdgeInsets.symmetric(horizontal: 9),
                padding: const EdgeInsetsDirectional.only(end: 6),
                decoration: BoxDecoration(
                  color: context.color.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: AlignmentDirectional.centerEnd,
                child: progress < 82
                    ? Text(
                        '$progress%',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const SizedBox(),
              ),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: progress / 100,
                child: Container(
                  height: 22,
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  margin: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: AlignmentDirectional.centerEnd,
                  child: progress >= 82
                      ? Text(
                          '$progress%',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.color.onPrimary,
                            fontSize: 10,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
