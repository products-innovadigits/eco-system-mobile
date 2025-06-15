import 'package:eco_system/utility/export.dart';

import '../model/file_model.dart';
import '../repo/talent_pool_repo.dart';

class TalentPoolBloc extends Bloc<AppEvent, AppState> {
  TalentPoolBloc() : super(Start()) {
    scrollController = ScrollController();
    fileNameController = TextEditingController();
    searchController = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getTalents);
    on<Sort>(_onSorting);
    on<Select>(onToggleSelection);
    on<SelectJob>(_onSelectJob);
    on<SelectTalent>(_onSelectTalent);
    on<ApplyFilters>(_onApplyFilters);
    on<Reset>(_onResetFilters);
    on<Export>(_onExport);
    on<Assign>(_onAssignJobs);
  }

  List<CandidateModel> talentsList = [];
  int? candidatesCount;
  List<int> selectedJobsList = [];
  late SearchEngine _engine;
  late ScrollController scrollController;

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

  CandidateFilterModel filterModel = const CandidateFilterModel();

  _onSorting(Sort event, Emitter<AppState> emit) async {
    selectedSorting = event.arguments as DropListModel?;
    emit(Done());
  }

  void onToggleSelection(Select event, Emitter<AppState> emit) async {
    activeSelection = event.arguments as bool;
    if (activeSelection == false) {
      selectedTalentsList.clear();
      selectedJobsList.clear();
    }
    emit(Done());
  }

  void _onSelectTalent(SelectTalent event, Emitter<AppState> emit) {
    bool selectAll =
        (event.arguments as Map<String, dynamic>?)?['selectAll'] as bool? ??
            false;
    int? talentId =
        (event.arguments as Map<String, dynamic>?)?['talentId'] as int?;

    if (selectAll) {
      selectedTalentsList
          .addAll(talentsList.map((talent) => talent.id ?? 0).toList());
    }
    if (talentId != null) {
      if (selectedTalentsList.contains(talentId)) {
        selectedTalentsList.remove(talentId);
      } else {
        selectedTalentsList.add(talentId);
      }
    }

    emit(Done());
  }

  void _onSelectJob(SelectJob event, Emitter<AppState> emit) {
    selectedJobsList = event.arguments as List<int>;
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
    filterModel = event.arguments as CandidateFilterModel;
    isFiltered = true;
    activeSelection = false;
    _engine = SearchEngine(searchText: searchController.text);
    talentsList.clear();
    add(Click(arguments: _engine));
  }

  void _onResetFilters(Reset event, Emitter<AppState> emit) {
    filterModel = const CandidateFilterModel();
    activeSelection = false;
    isFiltered = false;
    _engine = SearchEngine(searchText: searchController.text);
    talentsList.clear();
    add(Click(arguments: _engine));
  }

  void onCancelSearch() {
    if (searchController.text.isNotEmpty) {
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

      final talentModel = await TalentPoolService.getTalents(
        engine: _engine,
        filters: isFiltered ? filterModel : null,
      );
      candidatesCount = talentModel.meta?.total;
      if (talentModel.data != null && talentModel.data!.isNotEmpty) {
        talentsList.addAll(talentModel.data!);
      }

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

  Future<void> _onExport(Export event, Emitter<AppState> emit) async {
    final bool isExcel = event.arguments as bool;
    try {
      emit(Exporting());

      final FileModel fileUrl = await TalentPoolRepo.exportFile(
          fileName: fileNameController.text,
          isExcel: isExcel,
          selectedTalentsList: selectedTalentsList);
      if (fileUrl.url != null && fileUrl.url!.isNotEmpty) {
        CustomNavigator.pop();
        AppCore.successToastMessage(fileUrl.message);
        emit(Done());
        Future.delayed(Duration(milliseconds: 1500), () {
          LauncherHelper.openUrl(fileUrl.url!);
        });
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
  }

  Future<void> _onAssignJobs(Assign event, Emitter<AppState> emit) async {
    int? talentId = event.arguments as int?;
    try {
      emit(Exporting());

      final res = await TalentPoolRepo.assignToJob(
          selectedJobsList: selectedJobsList,
          selectedTalentsList:
              talentId != null ? [talentId] : selectedTalentsList);
      CustomNavigator.pop();
      if (res.status == 200) {
        selectedJobsList.clear();
        selectedTalentsList.clear();
        activeSelection = false;
        add(Click(arguments: SearchEngine()));
        AppCore.successMessage(res.message);
      } else {
        AppCore.errorMessage(res.message);
      }
      emit(Done());
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
    filterModel = const CandidateFilterModel();
    _engine = SearchEngine();
    return super.close();
  }
}
