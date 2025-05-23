import 'package:eco_system/features/ats/talent_pool/model/candidate_model.dart';
import 'package:eco_system/features/ats/talent_pool/repo/talent_pool_repo.dart';
import 'package:eco_system/features/ats/talent_pool/service/talent_service.dart';
import 'package:eco_system/utility/export.dart';

class TalentPoolBloc extends Bloc<AppEvent, AppState> {
  TalentPoolBloc() : super(Start()) {
    scrollController = ScrollController();
    fileNameController = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getTalents);
    on<Sort>(_onSorting);
    on<Select>(onToggleSelection);
    on<SelectTalent>(_onSelectTalent);
  }

  List<CandidateModel> talentsList = [];
  late SearchEngine _engine;
  late ScrollController scrollController;

  late TextEditingController fileNameController;
  List<int> selectedTalentsList = [];
  bool activeSelection = false;
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

  void _getTalents(AppEvent event, Emitter<AppState> emit) async {
    try {
      _engine = event.arguments as SearchEngine;

      if (_engine.currentPage == 0) {
        talentsList.clear();
        emit(Loading());
      } else {
        emit(Done(loading: true));
      }

      final newTalents = await TalentPoolService.getTalents(_engine);
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
    selectedTalentsList.clear();
    talentsList.clear();
    activeSelection = false;
    selectedSorting = null;
    _engine = SearchEngine();
    return super.close();
  }
}
