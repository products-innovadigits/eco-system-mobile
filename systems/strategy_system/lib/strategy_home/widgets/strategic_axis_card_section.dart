import 'package:core_system/core/widgets/custom_expansion_card.dart';

import '../../shared/strategy_exports.dart';

class StrategicAxisCardSection extends StatelessWidget {
  const StrategicAxisCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StrategicAxisBloc()..add(Click()),
      child: CustomExpansionCard(
        title: allTranslations.text(LocaleKeys.strategic_axis),
        action: InkWell(
          onTap: () =>
              CustomNavigator.push(Routes.STRATEGIC_AXES, arguments: true),
          child: Text(
            allTranslations.text(LocaleKeys.view_more),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.color.secondary,
            ),
          ),
        ),
        withExpanded: false,
        withMargin: false,
        child: BlocBuilder<StrategicAxisBloc, AppState>(
          builder: (context, state) {
            return switch (state) {
              Done(:final list) => _AxesGrid(
                axes: list as List<CustomFieldModel>,
              ),
              Empty() => CardEmptyState(height: _cardContentHeight(context)),
              Error() => TryAgainWidget(
                onTryAgain: () =>
                    context.read<StrategicAxisBloc>().add(Click()),
              ),
              _ => CustomShimmerContainer(
                height: _cardContentHeight(context),
                width: context.w,
              ),
            };
          },
        ),
      ),
    );
  }
}

double _cardContentHeight(BuildContext context) => context.h * 0.12;

/// The home card is a preview; the full list is behind "view more".
const int _maxHomeAxes = 6;

class _AxesGrid extends StatelessWidget {
  final List<CustomFieldModel> axes;

  const _AxesGrid({required this.axes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 6.w,
        childAspectRatio: 6,
      ),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Icon(Icons.circle, color: context.color.secondary, size: 10),
            SizedBox(width: 2.w),
            Expanded(
              // TODO(backend): ObjectActive/GetStrategicAxis has no objectives
              // count per axis; show it here as " (n)" once it is returned.
              child: Text(
                axes[index].name ?? '',
                style: context.textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
      itemCount: axes.length > _maxHomeAxes ? _maxHomeAxes : axes.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
