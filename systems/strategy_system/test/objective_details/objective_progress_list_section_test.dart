import 'package:core_system/core/core/core_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strategy_system/objective_details/bloc/objective_list_bloc.dart';
import 'package:strategy_system/objective_details/model/objective_indicator_model.dart';
import 'package:strategy_system/objective_details/widgets/objective_progress_list_section.dart';

class _FakeKpisBloc extends ObjectiveListBloc<ObjectiveKPIModel> {
  @override
  Future<dynamic> fetch(int id) async => Response(
    requestOptions: RequestOptions(),
    statusCode: 200,
    data: {
      'data': [
        // A whole number used to fail parsing the whole list.
        {'indicatorTitle': 'Customer satisfaction', 'kpiValue': 40},
        {'indicatorTitle': 'On-time delivery', 'kpiValue': 75.5},
      ],
    },
  );

  @override
  ObjectiveKPIModel fromJson(Map<String, dynamic> json) =>
      ObjectiveKPIModel.fromJson(json);
}

void main() {
  testWidgets('lists each item with its percentage', (tester) async {
    final bloc = _FakeKpisBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          home: Scaffold(
            body: BlocProvider<_FakeKpisBloc>.value(
              value: bloc,
              child:
                  ObjectiveProgressListSection<
                    _FakeKpisBloc,
                    ObjectiveKPIModel
                  >(
                    titleKey: 'kpis',
                    unitKey: 'scale',
                    itemTitle: (kpi) => kpi.kpiTitle,
                    itemValue: (kpi) => kpi.value,
                  ),
            ),
          ),
        ),
      ),
    );
    bloc.add(Click(arguments: 1));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Customer satisfaction'), findsOneWidget);
    expect(find.text('On-time delivery'), findsOneWidget);
    expect(find.text('40.0%'), findsOneWidget);
    expect(find.text('75.5%'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
  });
}
