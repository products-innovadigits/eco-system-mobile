import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/bsc/widgets/indicators_card_widget.dart';
import 'package:strategy_system/shared/bloc/bsc_objectives_bloc.dart';

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
    return BlocBuilder<BscObjectivesBloc, AppState>(
      builder: (context, state) {
        final bscBloc = context.read<BscObjectivesBloc>();
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
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        objectiveTitle,
                        maxLines: 2,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: bscBloc.expandedObjectiveId == index
                              ? context.color.secondary
                              : context.color.primary,
                          fontWeight: bscBloc.expandedObjectiveId == index
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    AnimatedExpansionArrowWidget(
                      isExpanded: bscBloc.expandedObjectiveId == index,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  padding: EdgeInsetsDirectional.only(start: 24.w),
                  child: Column(
                    children: [
                      IndicatorsCardWidget(
                        objectiveTitle: allTranslations.text(LocaleKeys.kpis),
                        indicators: kpis,
                        onTap: () => bscBloc.add(ToggleKpis(arguments: index)),
                        isExpanded: bscBloc.isKpisExpanded,
                        indicatorIcon: Assets.svgs.focus.path,
                      ),
                      SizedBox(height: 16.h),
                      IndicatorsCardWidget(
                        objectiveTitle: allTranslations.text(
                          LocaleKeys.initiatives,
                        ),
                        indicators: initiatives,
                        onTap: () =>
                            bscBloc.add(ToggleInitiatives(arguments: index)),
                        isExpanded: bscBloc.isInitiativesExpanded,
                        indicatorIcon: Assets.svgs.rocket.path,
                      ),
                      SizedBox(height: 24.h),
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
