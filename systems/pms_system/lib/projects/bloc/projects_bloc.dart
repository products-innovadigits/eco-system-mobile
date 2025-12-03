import 'package:pms_system/projects/bloc/projects_sorting_bloc.dart';
import 'package:pms_system/projects/bloc/projects_sorting_states.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsBloc extends Bloc<AppEvent, AppState> {
  ProjectsBloc({ProjectsSortingBloc? sortingBloc}) : super(Start()) {
    scrollController = ScrollController();
    searchTEC = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getObjectives);
    on<Refresh>(_onRefresh);

    // Listen to sorting changes
    _sortingBloc = sortingBloc;
    if (_sortingBloc != null) {
      _sortingBloc!.stream.listen((sortingState) {
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
          add(Click(arguments: _engine));
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

  final filter = BehaviorSubject<CustomFieldModel?>();

  Function(CustomFieldModel?) get updateFilter => filter.sink.add;

  Stream<CustomFieldModel?> get filterStream =>
      filter.stream.asBroadcastStream();

  final goingDown = BehaviorSubject<bool>();

  Function(bool) get updateGoingDown => goingDown.sink.add;

  Stream<bool> get goingDownStream => goingDown.stream.asBroadcastStream();

  customScroll(ScrollController controller) {
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
          add(Click(arguments: _engine));
        }
      }
    });
  }

  _getObjectives(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      // Update engine from event arguments, preserving state if needed
      final eventEngine = event.arguments as SearchEngine;
      _engine = eventEngine;

      // SOLUTION 1: Handle pagination with data models instead of widgets
      if (_engine.currentPage == 0) {
        _projects.clear(); // Clear data models instead of widgets
        emit(Loading());
      } else {
        // Emit loading state with current projects for pagination using Done state
        emit(
          Done(
            list: _projects, // Use 'list' property to store data models
            loading: true,
            reload: true,
          ),
        );
      }

      // Get sorting parameters from sorting bloc
      final sortingParams = _sortingBloc?.getSortingParams() ?? {};

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

        // Emit the new state with data models using Done state
        emit(
          Done(
            list: _projects, // Use 'list' property to store data models
            loading: false,
            reload: true,
          ),
        );
      } else {
        // Emit empty state if no projects found
        if (_projects.isEmpty) {
          emit(Empty());
        } else {
          // If we have projects but no new ones, just update the loading state
          emit(
            Done(
              list: _projects, // Use 'list' property to store data models
              loading: false,
              reload: true,
            ),
          );
        }
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
  }

  _onRefresh(AppEvent event, Emitter<AppState> emit) async {
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

    add(Click(arguments: _engine));
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
    scrollController.dispose();
    searchTEC?.dispose();
    return super.close();
  }
}
