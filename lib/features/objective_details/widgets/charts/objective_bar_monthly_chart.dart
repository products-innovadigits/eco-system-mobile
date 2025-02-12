import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../components/shimmer/custom_shimmer.dart';
import '../../../../core/app_state.dart';
import '../../bloc/objective_chart_month_bloc.dart';
import '../../model/objective_chart_month_model.dart';

class ObjectiveBarMonthlyChart extends StatelessWidget {
  const ObjectiveBarMonthlyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveChartMonthBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<ObjectiveChartMonthModel> list =
              state.list as List<ObjectiveChartMonthModel>;
          return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<ObjectiveChartMonthModel, String>>[
                LineSeries<ObjectiveChartMonthModel, String>(
                    dataSource: list,
                    xValueMapper: (ObjectiveChartMonthModel data, _) =>
                        data.categoryName,
                    yValueMapper: (ObjectiveChartMonthModel data, _) =>
                        data.value,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]);
        }
        if (state is Loading) {
          return CustomShimmerContainer(
            height: 130.h,
            width: context.w,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
