import 'package:core_system/core/widgets/custom_expansion_card.dart';

import '../../shared/strategy_exports.dart';

/// A home card of a strategy framework (BSC, OKR): a progress bar per item and
/// a link to the framework's screen.
class StrategyFrameworkCard extends StatelessWidget {
  final String title;
  final String route;
  final List<ObjectiveKPIModel> items;

  const StrategyFrameworkCard({
    super.key,
    required this.title,
    required this.route,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: title,
      action: InkWell(
        onTap: () => CustomNavigator.push(route),
        child: Text(
          allTranslations.text(LocaleKeys.view_more),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.color.secondary,
          ),
        ),
      ),
      withExpanded: false,
      withMargin: false,
      child: Column(children: [for (final item in items) _ItemRow(item: item)]),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final ObjectiveKPIModel item;

  const _ItemRow({required this.item});

  /// The item's `#RRGGBB` color; black when missing or malformed.
  Color get _color {
    final rgb = int.tryParse(
      (item.color ?? '').replaceFirst('#', ''),
      radix: 16,
    );
    return Color(0xff000000 | (rgb ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.kpiTitle ?? '',
              style: context.textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: ((item.value ?? 0) / 100).clamp(0.0, 1.0),
                  minHeight: 6.h,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
          Text('${item.value ?? ''}%', style: context.textTheme.labelSmall),
        ],
      ),
    );
  }
}
