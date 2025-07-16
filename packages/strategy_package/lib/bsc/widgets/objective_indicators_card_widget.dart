import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/bloc/bsc_bloc.dart';
import 'package:strategy_package/bsc/model/objectives_model.dart';
import 'package:strategy_package/bsc/widgets/indicators_card_widget.dart';

class ObjectiveIndicatorsCardWidget extends StatelessWidget {
  final String objectiveTitle;
  final List<IndicatorModel> initiatives;
  final List<IndicatorModel> kpis;
  final int index;

  const ObjectiveIndicatorsCardWidget({
    super.key,
    required this.objectiveTitle,
    required this.initiatives,
    required this.kpis,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BscBloc, AppState>(
      builder: (context, state) {
        final bscBloc = context.read<BscBloc>();
        return Container(
          padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            border: Border.all(
              color: bscBloc.expandedObjectiveId == index
                  ? context.color.secondary.withValues(alpha: 0.5)
                  : context.color.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => bscBloc.add(Expand(arguments: index)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bscBloc.expandedObjectiveId == index
                            ? context.color.secondary
                            : context.color.secondary.withValues(alpha: 0.1),
                      ),
                      child: Images(
                        image: Assets.svgs.target.path,
                        width: 14.w,
                        color: bscBloc.expandedObjectiveId == index
                            ? context.color.onPrimary
                            : context.color.primary,
                      ),
                    ),
                    8.sw,
                    Text(
                      objectiveTitle,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: bscBloc.expandedObjectiveId == index
                            ? context.color.secondary
                            : context.color.primary,
                        fontWeight: bscBloc.expandedObjectiveId == index
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    AnimatedExpansionArrowWidget(
                      isExpanded: bscBloc.expandedObjectiveId == index,
                    ),
                  ],
                ),
              ),
              16.sh,
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  padding: EdgeInsetsDirectional.only(start: 24.w),
                  child: Column(
                    children: [
                      IndicatorsCardWidget(
                        objectiveTitle: 'المؤشرات',
                        indicators: kpis,
                        onTap: () => bscBloc.add(ToggleKpis(arguments: index)),
                        isExpanded: bscBloc.isKpisExpanded,
                        indicatorIcon: Assets.svgs.focus.path,
                      ),
                      16.sh,
                      IndicatorsCardWidget(
                        objectiveTitle: 'المبادرات',
                        indicators: initiatives,
                        onTap: () =>
                            bscBloc.add(ToggleInitiatives(arguments: index)),
                        isExpanded: bscBloc.isInitiativesExpanded,
                        indicatorIcon: Assets.svgs.rocket.path,
                      ),
                      24.sh,
                    ],
                  ),
                ),
                crossFadeState: bscBloc.expandedObjectiveId == index
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 400),
              ),
            ],
          ),
        );
      },
    );
  }
}
