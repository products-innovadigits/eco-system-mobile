import 'package:bloc_test/bloc_test.dart';
import 'package:core_system/core/core/core_event.dart';
import 'package:core_system/core/core/core_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strategy_system/objective_details/bloc/objective_list_bloc.dart';
import 'package:strategy_system/objective_details/model/objective_indicator_model.dart';

/// [ObjectiveListBloc] answering with a canned response instead of the API.
class _FakeKpisBloc extends ObjectiveListBloc<ObjectiveKPIModel> {
  final Response response;
  int? requestedId;

  _FakeKpisBloc(this.response);

  @override
  Future<dynamic> fetch(int id) async {
    requestedId = id;
    return response;
  }

  @override
  ObjectiveKPIModel fromJson(Map<String, dynamic> json) =>
      ObjectiveKPIModel.fromJson(json);
}

Response _response(Object? data) =>
    Response(requestOptions: RequestOptions(), statusCode: 200, data: data);

void main() {
  blocTest<_FakeKpisBloc, AppState>(
    'loads the items of the objective it is clicked with',
    build: () => _FakeKpisBloc(
      _response({
        'data': [
          {'id': 1},
          {'id': 2},
        ],
      }),
    ),
    act: (bloc) => bloc.add(Click(arguments: 7)),
    expect: () => [
      isA<Loading>(),
      isA<Done>()
          .having((s) => s.list, 'list', hasLength(2))
          // Screens cast the list to their own model type.
          .having((s) => s.list, 'list', isA<List<ObjectiveKPIModel>>()),
    ],
    verify: (bloc) => expect(bloc.requestedId, 7),
  );

  for (final data in [
    {'data': []},
    {'data': null},
  ]) {
    blocTest<_FakeKpisBloc, AppState>(
      'is empty for $data',
      build: () => _FakeKpisBloc(_response(data)),
      act: (bloc) => bloc.add(Click(arguments: 7)),
      expect: () => [isA<Loading>(), isA<Empty>()],
    );
  }
}
