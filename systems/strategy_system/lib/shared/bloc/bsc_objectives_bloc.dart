import 'package:core_system/core/utility/export.dart';

class BscObjectivesBloc extends Bloc<AppEvent, AppState> {
  BscObjectivesBloc() : super(Start()) {
    on<Expand>(_onExpandObjective);
    on<ToggleKpis>(_onToggleKpis);
    on<ToggleInitiatives>(_onToggleInitiatives);
  }

  int selectedAxes = 0;

  int expandedObjectiveId = -1;
  bool isKpisExpanded = false;
  bool isInitiativesExpanded = false;


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

  void resetObjectivesExpansion(){
    expandedObjectiveId = -1;
    isKpisExpanded = false;
    isInitiativesExpanded = false;
  }
}
