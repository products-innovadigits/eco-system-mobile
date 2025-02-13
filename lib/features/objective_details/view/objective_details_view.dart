import 'package:eco_system/features/objective_details/bloc/objective_Initiatives_bloc.dart';
import 'package:eco_system/features/objective_details/bloc/objective_chart_annual_bloc.dart';
import 'package:eco_system/features/objective_details/bloc/objective_chart_month_bloc.dart';
import 'package:eco_system/features/objective_details/bloc/objective_details_bloc.dart';
import 'package:eco_system/features/objective_details/bloc/objective_kpis_bloc.dart';
import 'package:eco_system/features/objective_details/widgets/objective_kpis.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/animated_widget.dart';
import '../../../core/app_event.dart';
import '../widgets/objective_details_body.dart';
import '../widgets/objective_details_chart.dart';
import '../widgets/objective_initiatives.dart';

class ObjectiveDetailsView extends StatelessWidget {
  const ObjectiveDetailsView({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "", withBottomBorder: false),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ObjectiveDetailsBloc()..add(Click(arguments: id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveKPISBloc()..add(Click(arguments: id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveInitiativesBloc()..add(Click(arguments: id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveChartMonthBloc()..add(Click(arguments: id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveChartAnnualBloc()..add(Click(arguments: id)),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Expanded(
                  child: ListAnimator(
                data: [
                  ///Objective Details
                  ObjectiveDetailsBody(),

                  ///Objective indicators
                  ObjectiveKPIS(),

                  ///Objective indicators
                  ObjectiveInitiatives(),

                  ///Objective Chart
                  ObjectiveDetailsChart(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
