import 'package:eco_system/features/objective_details/bloc/objective_chart_annual_bloc.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/shimmer/custom_shimmer.dart';
import '../../../../core/app_state.dart';
import '../../bloc/objective_chart_month_bloc.dart';
import '../../model/objective_chart_model.dart';
import 'objective_bar_chart.dart';

class ObjectiveBarAnnualChart extends StatelessWidget {
  const ObjectiveBarAnnualChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveChartAnnualBloc, AppState>(
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
