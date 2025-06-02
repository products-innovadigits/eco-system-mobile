import 'package:eco_system/utility/export.dart';

class TalentPoolBloc extends Bloc<AppEvent, AppState> {
  TalentPoolBloc() : super(Start()) {
    scrollController = ScrollController();
    fileNameController = TextEditingController();
    searchController = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getTalents);
    on<Sort>(_onSorting);
    on<Select>(onToggleSelection);
    on<SelectTalent>(_onSelectTalent);
    on<ApplyFilters>(_onApplyFilters);
    on<Reset>(_onResetFilters);
  }

  List<CandidateModel> talentsList = [];
  late SearchEngine _engine;
  late ScrollController scrollController;
  Timer? _debounce;

  late TextEditingController fileNameController;
  late TextEditingController searchController;
  List<int> selectedTalentsList = [];
  bool activeSelection = false;
  bool isFiltered = false;
  List<DropListModel> sortingList = [
    DropListModel(
        id: 1, name: allTranslations.text(LocaleKeys.newest_to_oldest)),
    DropListModel(
        id: 2, name: allTranslations.text(LocaleKeys.oldest_to_newest)),
    DropListModel(id: 3, name: allTranslations.text(LocaleKeys.highest_price)),
    DropListModel(id: 4, name: allTranslations.text(LocaleKeys.lowest_price)),
    DropListModel(
        id: 5, name: allTranslations.text(LocaleKeys.most_experience)),
    DropListModel(
        id: 6, name: allTranslations.text(LocaleKeys.least_experience)),
  ];
  DropListModel? selectedSorting;

  List<String> selectedSkills = [];
  List<String> selectedTags = [];

  _onSorting(Sort event, Emitter<AppState> emit) async {
    selectedSorting = event.arguments as DropListModel?;
    emit(Done());
  }

  void onToggleSelection(Select event, Emitter<AppState> emit) async {
    activeSelection = event.arguments as bool;
    if (activeSelection == false) {
      selectedTalentsList.clear();
    }
    emit(Done());
  }

  void _onSelectTalent(SelectTalent event, Emitter<AppState> emit) {
    int talentId = event.arguments as int;
    if (event.arguments != null) {
      if (selectedTalentsList.contains(talentId)) {
        selectedTalentsList.remove(talentId);
      } else {
        selectedTalentsList.add(talentId);
      }
    }
    emit(Done());
  }

  void customScroll(ScrollController controller) {
    controller.addListener(() {
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage);
        add(Click(arguments: _engine));
      }
    });
  }

  void _onApplyFilters(ApplyFilters event, Emitter<AppState> emit) {
    final Map<String, dynamic> filters =
        event.arguments as Map<String, dynamic>;
    selectedSkills = (filters['skills'] as List<DropListModel>?)
            ?.map((skill) => skill.name ?? '')
            .toList() ??
        [];
    selectedTags = (filters['tags'] as List<DropListModel>?)
            ?.map((tag) => tag.name ?? '')
            .toList() ??
        [];

    isFiltered = true;
    activeSelection = false;
    _engine = SearchEngine(searchText: searchController.text);
    talentsList.clear();
    add(Click(arguments: _engine));
  }

  void _onResetFilters(Reset event, Emitter<AppState> emit) {
    selectedSkills.clear();
    selectedTags.clear();
    activeSelection = false;
    isFiltered = false;
    _engine = SearchEngine(searchText: searchController.text);
    talentsList.clear();
    add(Click(arguments: _engine));
  }

  void onSearching(String searchText) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      add(Click(arguments: SearchEngine(searchText: searchText)));
    });
  }

  void onCancelSearch() {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
      add(Click(arguments: SearchEngine()));
    }
  }

  void _getTalents(AppEvent event, Emitter<AppState> emit) async {
    try {
      _engine = event.arguments as SearchEngine;

      if (_engine.currentPage == 0) {
        talentsList.clear();
        emit(Loading());
      } else {
        emit(Done(loading: true));
      }

      final newTalents = await TalentPoolService.getTalents(
        engine: _engine,
        skills: selectedSkills,
        tags: selectedTags,
      );
      talentsList.addAll(newTalents);

      if (talentsList.isNotEmpty) {
        emit(Done());
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    fileNameController.dispose();
    searchController.dispose();
    selectedTalentsList.clear();
    talentsList.clear();
    activeSelection = false;
    selectedSorting = null;
    selectedSkills.clear();
    selectedTags.clear();
    _engine = SearchEngine();
    return super.close();
  }
}
