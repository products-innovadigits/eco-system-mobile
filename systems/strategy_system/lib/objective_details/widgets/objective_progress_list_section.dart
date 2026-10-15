import '../../shared/strategy_exports.dart';

/// One of the objective's progress lists (KPIs, initiatives): a row per item
/// with its title, a progress bar and the percentage. Fed by a bloc of type
/// [B] that emits [Done] with a list of [T].
class ObjectiveProgressListSection<B extends StateStreamable<AppState>, T>
    extends StatelessWidget {
  final String titleKey;
  final String unitKey;
  final String? Function(T item) itemTitle;
  final double? Function(T item) itemValue;

  const ObjectiveProgressListSection({
    super.key,
    required this.titleKey,
    required this.unitKey,
    required this.itemTitle,
    required this.itemValue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, AppState>(
      builder: (context, state) {
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: CustomShimmerContainer(height: 130.h, width: context.w),
          );
        }
        if (state is! Done) return const SizedBox();

        final items = state.list as List<T>;
        return ObjectiveDetailsLayout(
          title: allTranslations.text(titleKey),
          subTitle: '${items.length} ${allTranslations.text(unitKey)}',
          child: Column(
            children: [
              for (final item in items)
                _ProgressRow(title: itemTitle(item), value: itemValue(item)),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String? title;
  final double? value;

  const _ProgressRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final color = context.color.secondary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(title ?? '', style: context.textTheme.bodySmall),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: ((value ?? 0) / 100).clamp(0.0, 1.0),
                  minHeight: 6.h,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
          Text('${value ?? ''}%', style: context.textTheme.labelSmall),
        ],
      ),
    );
  }
}
