import 'package:eco_system/utility/export.dart';

class SearchBloc extends Bloc<AppEvent, AppState> {
  SearchBloc() : super(Start()) {
    scrollController = ScrollController();
    customScroll(scrollController);
    // on<GetTalents>(_getTalents);
    on<GetJobs>(_getJobs);
    on<TapSearch>(_onTapSearch);
    on<Searching>(_onSearching);
    on<CancelSearch>(_onCancelSearch);
  }

  List<CandidateModel> talentsList = [];
  List<JobDataModel> jobsList = [];
  late SearchEngine _engine;
  late ScrollController scrollController;
  TextEditingController searchController = TextEditingController();
  bool isActiveSearching = false;
  Timer? _debounce;

  void _onTapSearch(TapSearch event, Emitter<AppState> emit) {
    isActiveSearching = true;
    emit(Done());
  }

  void _onSearching(Searching event, Emitter<AppState> emit) {
    final searchEnum = event.arguments as SearchEnum;

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchEnum == SearchEnum.talentPool) {
        add(GetTalents(
            arguments: SearchEngine(searchText: searchController.text)));
      } else if (searchEnum == SearchEnum.jobs) {
        add(GetJobs(
            arguments: SearchEngine(searchText: searchController.text)));
      } else if (searchEnum == SearchEnum.candidates) {
        add(GetCandidates(
            arguments: SearchEngine(searchText: searchController.text)));
      }
    });

    emit(Done());
  }

  void _onCancelSearch(CancelSearch event, Emitter<AppState> emit) {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
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

  // void _getTalents(AppEvent event, Emitter<AppState> emit) async {
  //   try {
  //     _engine = event.arguments as SearchEngine;
  //
  //     if (_engine.currentPage == 0) {
  //       talentsList.clear();
  //       emit(Loading());
  //     } else {
  //       emit(Done(loading: true));
  //     }
  //
  //     final newTalents = await TalentPoolService.getTalents(engine: _engine);
  //     talentsList.addAll(newTalents);
  //
  //     if (talentsList.isNotEmpty) {
  //       emit(Done());
  //     } else {
  //       emit(Empty());
  //     }
  //   } catch (e) {
  //     AppCore.errorMessage(allTranslations.text('something_went_wrong'));
  //     emit(Error());
  //   }
  // }

  void _getJobs(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      _engine = event.arguments as SearchEngine;

      if (_engine.currentPage == 0) {
        jobsList.clear();
        emit(Loading());
      } else {
        emit(Done(loading: true));
      }

      final jobs = await JobsService.getJobs(engine: _engine);

      jobsList.addAll(jobs);

      if (jobsList.isNotEmpty) {
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
    searchController.dispose();
    scrollController.dispose();
    _engine = SearchEngine();
    isActiveSearching = false;
    _debounce?.cancel();
    return super.close();
  }
}
