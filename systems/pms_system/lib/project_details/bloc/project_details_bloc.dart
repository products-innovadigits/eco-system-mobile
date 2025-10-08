import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsBloc extends Bloc<AppEvent, AppState> {
  ProjectDetailsBloc() : super(Start()) {
    on<Click>(_onClick);
    on<Select>(_onSelectTab);
  }

  ProjectDetailsEnum selectedTab = ProjectDetailsEnum.mainInfo;
  ProjectDetailsModel? _cachedModel;

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
    emit(Loading());

    Response res = await ProjectDetailsRepo.getProjectDetails(
      event.arguments as int,
    );

    if (res.statusCode == 200 && res.data != null && res.data["data"] != null) {
      ProjectDetailsModel model = ProjectDetailsModel.fromJson(
        res.data["data"],
      );
      _cachedModel = model; // Cache the model
      emit(Done(model: model));
    } else {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }

  Future<void> _onSelectTab(Select event, Emitter<AppState> emit) async {
    final ProjectDetailsEnum tab = event.arguments as ProjectDetailsEnum;
    if (selectedTab != tab) {
      selectedTab = tab;
    }
    
    // Emit Done with the cached model
    if (_cachedModel != null) {
      emit(Done(model: _cachedModel!));
    } else {
      // If no cached model, emit error or handle appropriately
      emit(Error());
    }
  }
}
