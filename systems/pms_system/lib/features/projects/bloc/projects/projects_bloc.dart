import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/projects/bloc/filtration/projects_filtration_bloc.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_events.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_state.dart';
import 'package:pms_system/features/projects/bloc/sorting/projects_sorting_bloc.dart';
import 'package:pms_system/features/projects/bloc/sorting/projects_sorting_states.dart';
import 'package:pms_system/features/projects/model/projects_model.dart';
import 'package:pms_system/features/projects/repo/projects_repo.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({ProjectsSortingBloc? sortingBloc})
    : super(const ProjectsInitial()) {
    scrollController = ScrollController();
    searchTEC = TextEditingController();
    customScroll(scrollController);
    on<LoadProjects>(_getObjectives);
    on<RefreshProjects>(_onRefresh);

    // Listen to sorting changes
    _sortingBloc = sortingBloc;
    if (_sortingBloc != null) {
      _sortingSubscription = _sortingBloc!.stream.listen((sortingState) {
        if (sortingState is SortingApplied || sortingState is SortingReset) {
          // Refresh projects when sorting is applied or reset
          // Preserve existing filter parameters when resetting sorting
          // Reset pagination when sorting changes
          _engine = SearchEngine(
            query: _getCurrentFilterParams(),
            currentPage: 0,
            maxPages: 1,
            totalCount: 0,
          );
          _projects.clear(); // Clear data models instead of widgets
          add(LoadProjects(searchEngine: _engine));
        }
      });
    }
  }

  late SearchEngine _engine = SearchEngine();

  final List<ProjectDetailsModel> _projects = [];

  late ScrollController scrollController;
  TextEditingController? searchTEC;

  // Reference to sorting bloc
  ProjectsSortingBloc? _sortingBloc;
  StreamSubscription? _sortingSubscription;

  final filter = BehaviorSubject<CustomFieldModel?>();

  Function(CustomFieldModel?) get updateFilter => filter.sink.add;

  Stream<CustomFieldModel?> get filterStream =>
      filter.stream.asBroadcastStream();

  final goingDown = BehaviorSubject<bool>();

  Function(bool) get updateGoingDown => goingDown.sink.add;

  Stream<bool> get goingDownStream => goingDown.stream.asBroadcastStream();

  void customScroll(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        updateGoingDown(false);
      } else {
        updateGoingDown(true);
      }
      // Only trigger pagination if we haven't reached the last page
      if (_engine.hasMorePages) {
        bool scroll = AppCore.scrollListener(
          controller,
          _engine.maxPages,
          _engine.currentPage,
        );
        if (scroll) {
          // Increment currentPage for next page load
          // The _getObjectives method will use nextPageIndex to request the correct page
          _engine.updateCurrentPage(_engine.currentPage + 1);
          add(LoadProjects(searchEngine: _engine));
        }
      }
    });
  }

  Future<void> _getObjectives(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(const ProjectsLoading());
    try {
      // Update engine from event, preserving state if needed
      _engine = event.searchEngine;

      // SOLUTION 1: Handle pagination with data models instead of widgets
      if (_engine.currentPage == 0) {
        _projects.clear(); // Clear data models instead of widgets
        emit(const ProjectsLoading());
      } else {
        // Emit loading state with current projects for pagination
        emit(
          ProjectsLoaded(
            projects: _projects,
            isLoadingMore: true,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      }

      // Get sorting parameters from sorting bloc
      final sortingParams = _sortingBloc?.getSortingParams() ?? {};
      final filterParams = _getCurrentFilterParams();

      // Use nextPageIndex which converts 0-based to 1-based for API
      int pageIndexToRequest = _engine.nextPageIndex;

      _engine.query = {
        ...?(_engine.query as Map<String, dynamic>?)?.entries
            .where((e) => e.value != null)
            .fold<Map<String, dynamic>>(
              {},
              (acc, e) => {...acc, e.key: e.value},
            ),
        ...sortingParams,
        ...filterParams,

        "searchKeyword": searchTEC?.text.trim(),
        "pageIndex": pageIndexToRequest,
        "pageSize": _engine.limit,
      };

      ProjectsModel res = await ProjectsRepo.getProjects(_engine);

      if (res.data?.items != null && res.data!.items!.isNotEmpty) {
        // SOLUTION 1: Add data models instead of creating widgets
        // This prevents widget recreation on every state emission
        _projects.addAll(res.data!.items!);

        // Sync pagination info from API response
        // The API returns the currentPage (1-based) that we just loaded
        // We convert it to 0-based and store it
        // This ensures currentPage reflects the last page we loaded
        if (res.data!.currentPage != null &&
            res.data!.totalPages != null &&
            res.data!.totalCount != null) {
          _engine.syncPaginationFromApi(
            apiCurrentPage: res.data!.currentPage!,
            totalPages: res.data!.totalPages!,
            totalCount: res.data!.totalCount!,
            pageSize: res.data!.pageSize,
            isLastPage: res.data!.isLastPage,
          );
        } else {
          _engine.updateCurrentPage(pageIndexToRequest - 1);
        }

        // Emit the new state with data models
        emit(
          ProjectsLoaded(
            projects: _projects,
            isLoadingMore: false,
            currentPage: _engine.currentPage,
            totalPages: _engine.maxPages,
            hasMore: _engine.hasMorePages,
          ),
        );
      } else {
        // Emit empty state if no projects found
        if (_projects.isEmpty) {
          emit(const ProjectsEmpty());
        } else {
          // If we have projects but no new ones, just update the loading state
          emit(
            ProjectsLoaded(
              projects: _projects,
              isLoadingMore: false,
              currentPage: _engine.currentPage,
              totalPages: _engine.maxPages,
              hasMore: _engine.hasMorePages,
            ),
          );
        }
      }
    } catch (e) {
      emit(const ProjectsFailure(message: 'Failed to load projects'));
    }
  }

  Future<void> _onRefresh(
    RefreshProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    final filterParams = _getCurrentFilterParams();
    final sortingParams = _sortingBloc?.getSortingParams() ?? {};
    // Reset pagination when refreshing
    _engine = SearchEngine(
      query: {...filterParams, ...sortingParams},
      currentPage: 0,
      maxPages: 1,
      totalCount: 0,
    );
    _projects.clear();

    add(LoadProjects(searchEngine: _engine));
  }

  // Helper method to get current filter parameters from filtration bloc
  Map<String, dynamic> _getCurrentFilterParams() {
    final filtrationBloc = ProjectsFiltrationBloc.instance;
    final params = <String, dynamic>{};

    if (filtrationBloc.selectedStatus != null) {
      params['status'] = filtrationBloc.selectedStatus!.name;
    }
    if (filtrationBloc.selectedCategory != null) {
      params['projectCategoryId'] = filtrationBloc.selectedCategory!.id;
    }
    if (filtrationBloc.selectedRisk != null) {
      params['riskLevelId'] = filtrationBloc.selectedRisk!.id;
    }
    if (filtrationBloc.selectedPriority != null) {
      params['periortyLevelId'] = filtrationBloc.selectedPriority!.id;
    }
    if (filtrationBloc.pickedStartCtrl.text.isNotEmpty) {
      params['startDate'] = filtrationBloc.pickedStartCtrl.text;
    }
    if (filtrationBloc.pickedEndCtrl.text.isNotEmpty) {
      params['endDate'] = filtrationBloc.pickedEndCtrl.text;
    }

    return params;
  }

  @override
  Future<void> close() {
    // Cancel stream subscriptions
    _sortingSubscription?.cancel();
    filter.close();
    goingDown.close();

    // Dispose controllers
    scrollController.dispose();
    searchTEC?.dispose();

    return super.close();
  }
}
