import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/repo/bsc_repo.dart';

class BscBloc extends Bloc<AppEvent, AppState> {
  BscBloc() : super(Start()) {
    on<Click>(_getBscData);
    on<Select>(_onChangeSelectedAxes);
    on<Expand>(_onExpandObjective);
    on<ToggleKpis>(_onToggleKpis);
    on<ToggleInitiatives>(_onToggleInitiatives);
    on<ToggleMessages>(_onToggleMessages);
  }

  int selectedAxes = 0;
  String visionDesc = '';
  List<StrategicAxisModel> axes = [];
  List<ValueModel> values = [];
  List<MissionModel> messages = [];
  List<ManzorModel> perspectives = [];

  int expandedObjectiveId = -1;
  bool isKpisExpanded = false;
  bool isInitiativesExpanded = false;
  bool isMessagesExpanded = false;

  void _onChangeSelectedAxes(AppEvent event, Emitter<AppState> emit) {
    int selectedAxesId = event.arguments as int;
    selectedAxes = selectedAxesId;
    emit(Done());
  }

  void _onExpandObjective(Expand event, Emitter<AppState> emit) {
    final objId = event.arguments as int;
    if (expandedObjectiveId == objId) {
      expandedObjectiveId = -1;
    } else {
      expandedObjectiveId = objId;
      isKpisExpanded = false;
      isInitiativesExpanded = false;
    }
    emit(Done());
  }

  void _onToggleKpis(ToggleKpis event, Emitter<AppState> emit) {
    if (expandedObjectiveId == event.arguments as int) {
      isKpisExpanded = !isKpisExpanded;
      emit(Done());
    }
  }

  void _onToggleInitiatives(ToggleInitiatives event, Emitter<AppState> emit) {
    if (expandedObjectiveId == event.arguments as int) {
      isInitiativesExpanded = !isInitiativesExpanded;
      emit(Done());
    }
  }

  void _onToggleMessages(ToggleMessages event, Emitter<AppState> emit) {
    isMessagesExpanded = !isMessagesExpanded;
    emit(Done());
  }

  void resetObjectivesExpansion(){
    expandedObjectiveId = -1;
    isKpisExpanded = false;
    isInitiativesExpanded = false;
  }

  ///APIs calls
  Future<void> _getBscData(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      final BscModel res = await BscRepo.getBscData();

      if (res.data != null) {
        visionDesc = res.data?.title ?? '';
        axes = res.data?.strategicAxises ?? [];
        messages = res.data?.missions ?? [];
        values = res.data?.values ?? [];
        perspectives = res.data?.manzors ?? [];
        emit(Done());
      } else {
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.something_went_wrong),
      );
      emit(Error());
    }
  }
}
