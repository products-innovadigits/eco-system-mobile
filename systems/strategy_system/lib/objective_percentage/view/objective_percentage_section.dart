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
          if (state is Loading) {
            return _buildLoadingShimmer(context);
          }
          if (state is Done) {
            List<ObjectivePercentageModel> objectives =
                state.list as List<ObjectivePercentageModel>;
            return _buildPercentageChartSection(
              context,
              objectives: objectives,
              isStrategyHome: isStrategyHome,
            );
          }
          return const EmptyContainer();
        },
      ),
    );
  }
}

Widget _buildLoadingShimmer(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: CustomShimmerContainer(height: context.h * 0.2, width: context.w),
  );
}

Widget _buildPercentageChartSection(
  BuildContext context, {
  required List<ObjectivePercentageModel> objectives,
  required bool isStrategyHome,
}) {
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
