import 'package:eco_system/features/ats/repo/filtration_repo.dart';
import 'package:eco_system/utility/export.dart';

class FiltrationBloc extends Bloc<AppEvent, AppState> {
  FiltrationBloc() : super(Start()) {
    on<PickSkill>(_onAddSkill);
    on<Click>(_getTags);
    on<PickTag>(_onAddTag);
    on<RemoveSkill>(_onRemoveSkill);
    on<RemoveKeywords>(_onRemoveTag);
    on<ExpandSkills>(_onToggleSkillsExpanded);
    on<ExpandKeywords>(_onToggleKeywordsExpanded);
  }

  final TextEditingController skillController = TextEditingController();
  final TextEditingController expectedSalaryFromController =
      TextEditingController();
  final TextEditingController expectedSalaryToController =
      TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController experienceToController = TextEditingController();
  final TextEditingController experienceFromController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController applicationDateController =
      TextEditingController();
  final TextEditingController compatibilityRateController =
      TextEditingController();
  bool expandSkills = false;
  bool expandTags = false;

  final List<DropListModel> tagsList = [];
  final List<DropListModel> currencies = [
    DropListModel(id: 1, name: 'ر.س'),
    DropListModel(id: 2, name: 'ج.م'),
  ];
  final List<DropListModel> genders = [
    DropListModel(id: 1, name: 'ذكر'),
    DropListModel(id: 2, name: 'انثى'),
  ];
  final List<DropListModel> locations = [
    DropListModel(id: 1, name: 'مصر'),
    DropListModel(id: 2, name: 'السعودية'),
    DropListModel(id: 3, name: 'الامارات'),
    DropListModel(id: 4, name: 'الكويت'),
  ];
  final List<DropListModel> qualified = [
    DropListModel(id: 1, name: 'مؤهل'),
    DropListModel(id: 2, name: 'غير مؤهل'),
  ];

  List<DropListModel> selectedSkills = [];
  List<DropListModel> selectedTags = [];


  void _onAddSkill(PickSkill event, Emitter<AppState> emit) {
    final skill = event.arguments as DropListModel;
    if (!selectedSkills.contains(skill) && skillController.text.isNotEmpty) {
      selectedSkills.add(skill);
      skillController.clear();
      emit(Done());
    }
  }

  void _onAddTag(PickTag event, Emitter<AppState> emit) {
    final tag = event.arguments as DropListModel;
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
      tagsList.remove(tag);
      expandTags = false;
      emit(Done());
    }
  }

  void _onRemoveSkill(RemoveSkill event, Emitter<AppState> emit) {
    final skill = event.arguments as DropListModel;
    selectedSkills.remove(skill);
    emit(Done());
  }

  void _onRemoveTag(RemoveKeywords event, Emitter<AppState> emit) {
    final tag = event.arguments as DropListModel;
    selectedTags.remove(tag);
    tagsList.add(tag);
    emit(Done());
  }

  void _onToggleSkillsExpanded(ExpandSkills event, Emitter<AppState> emit) {
    expandSkills = !expandSkills;
    if (expandTags) {
      expandTags = false;
    }
    emit(Done());
  }

  void _onToggleKeywordsExpanded(ExpandKeywords event, Emitter<AppState> emit) {
    expandTags = !expandTags;
    if (expandSkills) {
      expandSkills = false;
    }
    emit(Done());
  }

  void _getTags(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      final res = await FiltrationRepo.getTags();

      if (res.data != null && res.data!.isNotEmpty) {
        for (var tag in res.data!) {
          if (tag.value != null) tagsList.add(DropListModel(name: tag.value));
        }
      }

      if (tagsList.isNotEmpty) {
        emit(Done());
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));
      emit(Error());
    }
  }

  void reset() {
    selectedSkills.clear();
    expandSkills = false;
    selectedTags.clear();
    expandTags = false;
    expectedSalaryFromController.clear();
    expectedSalaryToController.clear();
    experienceToController.clear();
    experienceFromController.clear();
    currencyController.clear();
    locationController.clear();
    applicationDateController.clear();
    compatibilityRateController.clear();
    skillController.clear();
  }

  @override
  Future<void> close() {
    experienceToController.dispose();
    experienceFromController.dispose();
    expectedSalaryFromController.dispose();
    expectedSalaryToController.dispose();
    currencyController.dispose();
    locationController.dispose();
    applicationDateController.dispose();
    compatibilityRateController.dispose();
    return super.close();
  }
}
