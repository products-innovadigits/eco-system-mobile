import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/widgets/indicators_card_widget.dart';
import 'package:strategy_package/shared/bloc/bsc_objectives_bloc.dart';

class StrategicObjectivesCard extends StatelessWidget {
  final String objectiveTitle;
  final List<IndicatorModel> initiatives;
  final List<IndicatorModel> kpis;
  final int index;

  const StrategicObjectivesCard({
    super.key,
    required this.objectiveTitle,
    required this.initiatives,
    required this.kpis,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BscObjectivesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<BscObjectivesBloc>();
        return Container(
          padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            border: Border.all(
              color: bloc.expandedObjectiveId == index
                  ? context.color.secondary.withValues(alpha: 0.5)
                  : context.color.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => bloc.add(Expand(arguments: index)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bloc.expandedObjectiveId == index
                            ? context.color.secondary
                            : context.color.secondary.withValues(alpha: 0.1),
                      ),
                      child: Images(
                        image: Assets.svgs.target.path,
                        width: 14.w,
                        color: bloc.expandedObjectiveId == index
                            ? context.color.onPrimary
                            : context.color.primary,
                      ),
                    ),
                    8.sw,
                    Text(
                      objectiveTitle,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: bloc.expandedObjectiveId == index
                            ? context.color.secondary
                            : context.color.primary,
                        fontWeight: bloc.expandedObjectiveId == index
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    AnimatedExpansionArrowWidget(
                      isExpanded: bloc.expandedObjectiveId == index,
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
                        onTap: () => bloc.add(ToggleKpis(arguments: index)),
                        isExpanded: bloc.isKpisExpanded,
                        indicatorIcon: Assets.svgs.focus.path,
                      ),
                      16.sh,
                      IndicatorsCardWidget(
                        objectiveTitle: 'المبادرات',
                        indicators: initiatives,
                        onTap: () =>
                            bloc.add(ToggleInitiatives(arguments: index)),
                        isExpanded: bloc.isInitiativesExpanded,
                        indicatorIcon: Assets.svgs.rocket.path,
                      ),
                      24.sh,
                    ],
                  ),
                ),
                crossFadeState: bloc.expandedObjectiveId == index
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
