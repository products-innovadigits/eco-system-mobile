import 'package:strategy_package/objective_details/widgets/charts/objective_bar_chart.dart';

import '../../../shared/strategy_exports.dart';

class ObjectiveBarMonthlyChart extends StatelessWidget {
  const ObjectiveBarMonthlyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveChartMonthBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<ObjectiveChartModel> list =
              state.list as List<ObjectiveChartModel>;
          return ObjectiveBarChart(data: list);
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: CustomShimmerContainer(
              height: 200.h,
              width: context.w,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
