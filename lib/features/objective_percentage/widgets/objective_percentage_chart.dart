import 'package:eco_system/components/shimmer/custom_shimmer.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import '../bloc/objective_percentage_bloc.dart';
import '../model/objective_percentage_model.dart';

class ObjectivePercentageChart extends StatefulWidget {
  const ObjectivePercentageChart({super.key, required this.objectives});
  final List<ObjectivePercentageModel> objectives;

  @override
  State<ObjectivePercentageChart> createState() =>
      _ObjectivePercentageChartState();
}

class _ObjectivePercentageChartState extends State<ObjectivePercentageChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
              sectionsSpace: 5.w,
              centerSpaceRadius: 50.w,
              sections: showingSections(),
            ),
          ),
          BlocBuilder<ObjectivePercentageBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                return SizedBox(
                  width: 80.w,
                  child: FittedBox(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: allTranslations.text("objective_percentage"),
                        style: AppTextStyles.w600
                            .copyWith(fontSize: 12, color: Styles.HEADER),
                        children: [
                          TextSpan(
                            text: "\n${state.data ?? 0}",
                            style: AppTextStyles.w700.copyWith(
                                fontSize: 14, color: Styles.PRIMARY_COLOR),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state is Loading) {
                return CustomShimmerContainer(width: 80.w, height: 16.h);
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.objectives.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.w : 16.w;
      final radius = isTouched ? 70.w : 50.w;
      const shadows = [
        Shadow(color: Colors.grey, blurRadius: 5, offset: Offset(1, 1))
      ];
      return PieChartSectionData(
        color: Styles.objectivesColors[i],
        title: '${widget.objectives[i].value?.toStringAsFixed(2)}%',
        value: widget.objectives[i].value,
        radius: radius,
        borderSide: BorderSide(
          color: Styles.LIGHT_GREY_BORDER,
        ),
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          shadows: shadows,
        ),
      );
    });
  }
}
