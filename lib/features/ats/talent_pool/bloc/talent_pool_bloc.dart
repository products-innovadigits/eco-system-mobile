import 'package:eco_system/utility/export.dart';

class TalentPoolBloc extends Bloc<AppEvent, AppState> {
  TalentPoolBloc() : super(Start()) {
    on<Click>(onClick);
    on<Sort>(_onSorting);
    on<Select>(onToggleSelection);
    on<SelectTalent>(_onSelectTalent);
  }

  TextEditingController fileNameController = TextEditingController();
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

  onClick(AppEvent event, Emitter<AppState> emit) async {
    emit(Done());
    // try {
    //   emit(Loading());
    //
    //   Response res = await JobsRepo.getObjectivePercentage();
    //
    //   if (res.statusCode == 200 &&
    //       res.data != null &&
    //       res.data["data"] != null &&
    //       res.data["data"]["totalPercentage"] != null) {
    //     emit(Done(data: res.data["data"]["totalPercentage"]));
    //   } else {
    //     AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    //     emit(Error());
    //   }
    // } catch (e) {
    //   AppCore.errorMessage(allTranslations.text('something_went_wrong'));
    //
    //   emit(Error());
    // }
  }
}
