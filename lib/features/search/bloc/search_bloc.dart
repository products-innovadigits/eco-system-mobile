import 'dart:async';

import 'package:eco_system/features/ats/talent_pool/model/candidate_model.dart';
import 'package:eco_system/features/ats/talent_pool/service/talent_service.dart';
import 'package:eco_system/utility/export.dart';

class SearchBloc extends Bloc<AppEvent, AppState> {
  SearchBloc() : super(Start()) {
    scrollController = ScrollController();
    customScroll(scrollController);
    on<Click>(_getTalents);
    on<TapSearch>(_onTapSearch);
    on<Searching>(_onSearching);
    on<CancelSearch>(_onCancelSearch);
  }

  List<CandidateModel> talentsList = [];
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
      final context = CustomNavigator.navigatorState.currentContext;
      if (searchEnum == SearchEnum.talentPool) {
        add(Click(arguments: SearchEngine(searchText: searchController.text)));
      } else if (searchEnum == SearchEnum.jobs) {
        context?.read<JobsBloc>().add(
              Click(arguments: SearchEngine()),
            );
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

  void _getTalents(AppEvent event, Emitter<AppState> emit) async {
    try {
      _engine = event.arguments as SearchEngine;

      if (_engine.currentPage == 0) {
        talentsList.clear();
        emit(Loading());
      } else {
        emit(Done(loading: true));
      }

      final newTalents = await TalentPoolService.getTalents(engine: _engine);
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
    searchController.dispose();
    scrollController.dispose();
    _engine = SearchEngine();
    isActiveSearching = false;
    _debounce?.cancel();
    return super.close();
  }
}
