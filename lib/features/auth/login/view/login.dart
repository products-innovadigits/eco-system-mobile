import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../../core/app_event.dart';
import '../../../../helpers/styles.dart';
import '../../../../helpers/text_styles.dart';
import '../../../objective_details/model/objective_chart_month_model.dart';
import '../bloc/login_bloc.dart';
import '../widgets/bar_trial_11.dart';
import '../widgets/remember_me.dart';
import '../widgets/welcome_widget.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100.h,
          leadingWidth: 100.w,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Styles.logo(
                color: Styles.PRIMARY_COLOR, width: 50.w, height: 50.w),
          )),
      body: SafeArea(child: BarChartTrial11(
        list: [
          ObjectiveChartMonthModel(categoryName: "xxx",value: 100),
          ObjectiveChartMonthModel(categoryName: "yyy",value: 5),
          ObjectiveChartMonthModel(categoryName: "xhhhxx",value: 543),
          ObjectiveChartMonthModel(categoryName: "54red",value: 22),
          ObjectiveChartMonthModel(categoryName: "plkjn",value: 1234),
        ],
      )),
    );
  }
}
