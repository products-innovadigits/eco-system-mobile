import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectDetailsBloc
    extends Bloc<ProjectDetailsEvent, ProjectDetailsState> {
  final ProjectDetailsRepo repo;

  ProjectDetailsBloc({required this.repo})
    : super(const ProjectDetailsInitial()) {
    on<LoadProjectDetails>(_onLoadProjectDetails);
    on<LoadProjectTimeline>(_onLoadProjectTimeline);
    on<SelectProjectTab>(_onSelectTab);
  }

  ProjectDetailsEnum selectedTab = ProjectDetailsEnum.mainInfo;
  ProjectDetailsDataModel? _cachedModel;
  List<MilestoneModel>? _cachedMilestonesList;

  List<MilestoneModel>? get cachedMilestones => _cachedMilestonesList;

  Future<void> _onLoadProjectDetails(
    LoadProjectDetails event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    try {
      emit(const ProjectDetailsLoading());

      ProjectDetailsModel res = await repo.getProjectDetails(event.projectId);

      if (res.succeeded == true && res.data != null) {
        _cachedModel = res.data;
        emit(ProjectDetailsLoaded(projectDetails: res.data!));
      } else {
        emit(
          const ProjectDetailsFailure(
            message: 'Failed to load project details',
          ),
        );
      }
    } catch (e) {
      emit(
        const ProjectDetailsFailure(message: 'Failed to load project details'),
      );
    }
  }

  Future<void> _onLoadProjectTimeline(
    LoadProjectTimeline event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    try {
      emit(const ProjectTimelineLoading());

      Response res = await repo.projectTimeline(event.projectId);

      if (res.statusCode == 200 && res.data != null) {
        List<MilestoneModel> milestones = List<MilestoneModel>.from(
          res.data.map((x) => MilestoneModel.fromJson(x)),
        );
        _cachedMilestonesList = milestones; // Cache the milestones
        emit(ProjectTimelineLoaded(milestones: milestones));
      } else {
        emit(const ProjectTimelineFailure(message: 'Failed to load timeline'));
      }
    } catch (e) {
      emit(const ProjectTimelineFailure(message: 'Failed to load timeline'));
    }
  }

  Future<void> _onSelectTab(
    SelectProjectTab event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    final ProjectDetailsEnum tab = event.tab;
    if (selectedTab != tab) {
      selectedTab = tab;
    }
    if (_cachedModel != null) {
      // If switching to timeline tab and we have cached milestones, emit ProjectTimelineLoaded directly
      if (tab == ProjectDetailsEnum.timeline && _cachedMilestonesList != null) {
        emit(ProjectTimelineLoaded(milestones: _cachedMilestonesList!));
      } else {
        emit(ProjectDetailsLoaded(projectDetails: _cachedModel!));
        // If switching to timeline and no cached milestones, fetch them
        if (tab == ProjectDetailsEnum.timeline &&
            _cachedMilestonesList == null) {
          add(LoadProjectTimeline(projectId: _cachedModel?.id ?? 0));
        }
      }
    } else {
      emit(const ProjectDetailsFailure(message: 'No cached project details'));
    }
  }
}
