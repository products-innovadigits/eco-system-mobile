import 'package:core_system/core/components/system_switcher.dart';
import 'package:core_system/core/widgets/main_card_widget.dart';
import 'package:strategy_system/objective_percentage/widgets/chart_categories_section.dart';
import '../../shared/strategy_exports.dart';

class ObjectivePercentageSection extends StatelessWidget {
  final bool isStrategyHome;

  const ObjectivePercentageSection({super.key, this.isStrategyHome = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ObjectiveCategorizedBloc()..add(Click()),
        ),
        BlocProvider(
          create: (context) => ObjectivePercentageBloc()..add(Click()),
        ),
      ],
      child: BlocBuilder<ObjectiveCategorizedBloc, AppState>(
        builder: (context, state) {
          return switch (state) {
            // ── Loading ───────────────────────
            Loading() =>
              isStrategyHome
                  ? CustomShimmerContainer(
                      height: context.h * 0.2,
                      width: context.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    )
                  : SystemsSwitcher(),

            // ── Done ──────────────────────────
            Done(:final list) => _PercentageChartSection(
              objectives: list as List<ObjectivePercentageModel>,
              isStrategyHome: isStrategyHome,
            ),

            // ── Empty ─────────────────────────
            Empty() => const EmptyContainer(),

            // ── Default (error, etc.) ─────────
            _ => MainCardWidget(
              title: allTranslations.text(LocaleKeys.objective_percentage_rate),
              child: TryAgainWidget(
                onTryAgain: () {
                  context.read<ObjectiveCategorizedBloc>().add(Click());
                },
              ),
            ),
          };
        },
      ),
    );
  }
}

class _PercentageChartSection extends StatelessWidget {
  final bool isStrategyHome;
  final List<ObjectivePercentageModel> objectives;

  const _PercentageChartSection({
    required this.isStrategyHome,
    required this.objectives,
  });

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(LocaleKeys.objective_percentage_rate),
      onViewMoreTap: () => CustomNavigator.push(
        isStrategyHome ? Routes.OBJECTIVES : Routes.STRATEGY_LAYOUT,
      ),
      child: Column(
        children: [
          ObjectivePercentageChart(objectives: objectives),
          const SizedBox(height: 12),
          ChartCategoriesSection(objectives: objectives),
        ],
      ),
    );
  }
}
