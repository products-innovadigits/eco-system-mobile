import '../../shared/strategy_exports.dart';

/// Loads one of an objective's lists (KPIs, initiatives, chart points) when it
/// receives [Click] with the objective id: [Done] with the items, [Empty] when
/// there are none, [Error] when the call fails.
abstract class ObjectiveListBloc<T extends Mapper>
    extends Bloc<AppEvent, AppState> {
  ObjectiveListBloc() : super(Start()) {
    on<Click>(_onLoad);
  }

  /// Requests the list of the objective with [id].
  Future<dynamic> fetch(int id);

  T fromJson(Map<String, dynamic> json);

  Future<void> _onLoad(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      final Response res = await fetch(event.arguments as int);
      if (res.statusCode != 200 || res.data == null) {
        _fail(emit);
        return;
      }

      final data = res.data['data'];
      if (data == null || data.isEmpty) {
        emit(Empty());
        return;
      }
      // Typed as List<T>: screens cast `Done.list` to their own model list.
      emit(Done(list: <T>[for (final item in data) fromJson(item)]));
    } catch (_) {
      _fail(emit);
    }
  }

  void _fail(Emitter<AppState> emit) {
    AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    emit(Error());
  }
}

/// Chart points of the objective for one [ChartTime] period.
abstract class ObjectiveChartBloc
    extends ObjectiveListBloc<ObjectiveChartModel> {
  final ChartTime time;

  ObjectiveChartBloc(this.time);

  @override
  Future<dynamic> fetch(int id) =>
      ObjectiveDetailsRepo.getObjectiveChartData(id: id, time: time.name);

  @override
  ObjectiveChartModel fromJson(Map<String, dynamic> json) =>
      ObjectiveChartModel.fromJson(json);
}
