import 'package:pms_system/project_details/model/project_timeline_model.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsBloc extends Bloc<AppEvent, AppState> {
  ProjectDetailsBloc() : super(Start()) {
    on<Click>(_onClick);
    on<Get>(_onGet);
    on<Select>(_onSelectTab);
  }

  ProjectDetailsEnum selectedTab = ProjectDetailsEnum.mainInfo;
  ProjectDetailsModel? _cachedModel;
  List<MilestoneModel>? _cachedMilestonesList;

  // Getter to access cached milestones
  List<MilestoneModel>? get cachedMilestones => _cachedMilestonesList;

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ProjectDetailsRepo.getProjectDetails(
        event.arguments as int,
      );

      if (res.statusCode == 200 &&
          res.data != null &&
          res.data["data"] != null) {
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

  _onGet(AppEvent event, Emitter<AppState> emit) async {
    // try {
    emit(Getting());

    Response res = await ProjectDetailsRepo.projectTimeline(
      event.arguments as int,
    );

    if (res.statusCode == 200 && res.data != null) {
      List<MilestoneModel> milestones = List<MilestoneModel>.from(
        res.data.map((x) => MilestoneModel.fromJson(x)),
      );
      _cachedMilestonesList = milestones; // Cache the model
      emit(GettingDone(data: _cachedMilestonesList));
    } else {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(GettingError());
    }
    // } catch (e) {
    //   AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    //
    //   emit(GettingError());
    // }
  }

  Future<void> _onSelectTab(Select event, Emitter<AppState> emit) async {
    final ProjectDetailsEnum tab = event.arguments as ProjectDetailsEnum;
    if (selectedTab != tab) {
      selectedTab = tab;
    }
    if (_cachedModel != null) {
      // If switching to timeline tab and we have cached milestones, emit GettingDone directly
      if (tab == ProjectDetailsEnum.timeline && _cachedMilestonesList != null) {
        emit(GettingDone(data: _cachedMilestonesList));
      } else {
        emit(Done(model: _cachedModel!));
        // If switching to timeline and no cached milestones, fetch them
        if (tab == ProjectDetailsEnum.timeline && _cachedMilestonesList == null) {
          add(Get(arguments: _cachedModel?.id ?? 0));
        }
      }
    } else {
      // If no cached model, emit error or handle appropriately
      emit(Error());
    }
  }
}
