import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extintions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../helpers/styles.dart';

class GoalProgressChart extends StatefulWidget {
  const GoalProgressChart({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
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
          SizedBox(
            width: 80.w,
            child: FittedBox(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: allTranslations.text("goal_progress"),
                  style: AppTextStyles.w600
                      .copyWith(fontSize: 12, color: Styles.HEADER),
                  children: [
                    TextSpan(
                      text: "\n ${78}%",
                      style: AppTextStyles.w700
                          .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.w : 16.w;
      final radius = isTouched ? 70.w : 50.w;
      const shadows = [
        Shadow(color: Colors.grey, blurRadius: 5, offset: Offset(1, 1))
      ];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Styles.PRIMARY_COLOR,
            value: 20,
            radius: radius,
            borderSide: BorderSide(
              color: Styles.LIGHT_GREY_BORDER,
            ),
            title: '20%',
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.pink,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
