import 'package:eco_system/features/objective_details/bloc/objective_chart_annual_bloc.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/shimmer/custom_shimmer.dart';
import '../../../../core/app_state.dart';
import '../../../../helpers/styles.dart';
import '../../model/objective_chart_model.dart';
import 'objective_line_chart.dart';

class ObjectiveLineAnnualChart extends StatelessWidget {
  const ObjectiveLineAnnualChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveChartAnnualBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<ObjectiveChartModel> list =
              state.list as List<ObjectiveChartModel>;
          return Column(
            children: [
              ObjectiveLineChart(data: list),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                runSpacing: 8.w,
                spacing: 24.h,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Styles.PRIMARY_COLOR,
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          allTranslations.text("kpis"),
                          style: AppTextStyles.w400
                              .copyWith(fontSize: 14, color: Styles.HEADER),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Styles.SECONDARY_COLOR,
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          allTranslations.text("initiatives"),
                          style: AppTextStyles.w400
                              .copyWith(fontSize: 14, color: Styles.HEADER),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
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
