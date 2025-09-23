import 'package:pms_system/shared/pms_exports.dart';

class ProjectsBloc extends Bloc<AppEvent, AppState> {
  ProjectsBloc() : super(Start()) {
    scrollController = ScrollController();
    searchTEC = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getObjectives);
    on<Get>(_getSortingOptions);
    on<SelectSorting>(_onSelectSorting);
    on<ApplySorting>(_onApplySorting);
    on<ResetSorting>(_onResetSorting);
  }

  late SearchEngine _engine;
  final List<Widget> _cards = [];

  late ScrollController scrollController;
  TextEditingController? searchTEC;

  // Sorting properties
  List<DropListModel> sortingList = [];
  DropListModel? appliedSorting;
  DropListModel? selectedSorting;

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
      bool scroll = AppCore.scrollListener(
        controller,
        _engine.maxPages,
        _engine.currentPage,
      );
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage);
        add(Click(arguments: _engine));
      }
    });
  }

  // Sorting event handlers
  Future<void> _onSelectSorting(
    SelectSorting event,
    Emitter<AppState> emit,
  ) async {
    selectedSorting = event.arguments as DropListModel?;
    emit(Done(cards: _cards));
  }

  void _onApplySorting(ApplySorting event, Emitter<AppState> emit) {
    appliedSorting = selectedSorting;
    CustomNavigator.pop();
    _engine = SearchEngine();
    add(Click(arguments: _engine));
  }

  void _onResetSorting(ResetSorting event, Emitter<AppState> emit) {
    appliedSorting = null;
    selectedSorting = null;
    CustomNavigator.pop();
    _engine = SearchEngine();
    add(Click(arguments: _engine));
  }

  _getObjectives(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      _engine = event.arguments as SearchEngine;
      if (_engine.currentPage == 0) {
        _cards.clear();
        emit(Loading());
      } else {
        emit(Done(cards: _cards, loading: true));
      }

      _engine.query = {
        "searchKeyword": searchTEC?.text.trim(),
        "pageIndex": _engine.currentPage + 1,
        "pageSize": _engine.limit,
        if (appliedSorting?.key != null) "sortOptionId": appliedSorting!.key,
        ...?(_engine.query as Map<String, dynamic>?)?.entries
            .where((e) => e.value != null)
            .fold<Map<String, dynamic>>(
              {},
              (acc, e) => {...acc, e.key: e.value},
            ),
      };

      ProjectsModel res = await ProjectsRepo.getProjects(_engine);

      if (res.data != null && res.data!.isNotEmpty) {
        for (var objective in res.data ?? []) {
          _cards.add(ProjectCard(project: objective));
        }
        _engine.currentPage += 1;
        _engine.maxPages += 1;
        // _engine.updateCurrentPage(res.meta!.currPage!);
      }
      if (_cards.isNotEmpty) {
        emit(Done(cards: _cards));
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }

  _getSortingOptions(AppEvent event, Emitter<AppState> emit) async {
    if (sortingList.isNotEmpty) return;
    try {
      emit(Getting());

      Response model = await ProjectsRepo.getProjectSortingOptions();

      if (model.statusCode == 200 && model.data != null) {
        sortingList = (model.data['data'] as List)
            .map(
              (item) => DropListModel(
                id: item['id'],
                name: item['nameAr'],
                key: item['key'] ?? item['id'].toString(),
              ),
            )
            .toList();
        emit(Done(cards: _cards));
      } else {
        AppCore.errorMessage(allTranslations.text('something_went_wrong'));
        emit(Error());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    searchTEC?.dispose();
    return super.close();
  }
}
