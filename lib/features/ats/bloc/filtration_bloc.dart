import 'package:eco_system/utility/export.dart';

class FiltrationBloc extends Bloc<AppEvent, AppState> {
  FiltrationBloc() : super(Start()) {
    on<PickSkill>(_onAddSkill);
    on<PickKeyword>(_onAddKeyword);
    on<RemoveSkill>(_onRemoveSkill);
    on<RemoveKeywords>(_onRemoveKeyword);
    on<ExpandSkills>(_onToggleSkillsExpanded);
    on<ExpandKeywords>(_onToggleKeywordsExpanded);
  }

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
  bool expandKeywords = false;

  final List<DropListModel> skills = [
    DropListModel(id: 1, name: 'تصميم واجهة '),
    DropListModel(id: 2, name: 'تصميم مواقع'),
    DropListModel(id: 3, name: 'تصميم تطبيقات'),
    DropListModel(id: 4, name: 'تصميم تطبيقات'),
    DropListModel(id: 5, name: 'تصميم تطبيقات'),
    DropListModel(id: 6, name: 'تصميم تطبيقات'),
  ];

  final List<DropListModel> keywords = [
    DropListModel(id: 1, name: 'ui/ux designer'),
    DropListModel(id: 2, name: 'Communication Skills'),
    DropListModel(id: 3, name: 'Mobile App Development'),
    DropListModel(id: 4, name: 'Web App Development'),
    DropListModel(id: 5, name: 'Backend Development'),
    DropListModel(id: 6, name: 'QA'),
  ];
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
  List<DropListModel> selectedKeywords = [];

  void _onAddSkill(PickSkill event, Emitter<AppState> emit) {
    final skill = event.arguments as DropListModel;
    if (!selectedSkills.contains(skill)) {
      selectedSkills.add(skill);
      skills.remove(skill);
      expandSkills = false;
      emit(Done());
    }
  }

  void _onAddKeyword(PickKeyword event, Emitter<AppState> emit) {
    final keyword = event.arguments as DropListModel;
    if (!selectedKeywords.contains(keyword)) {
      selectedKeywords.add(keyword);
      keywords.remove(keyword);
      expandKeywords = false;
      emit(Done());
    }
  }

  void _onRemoveSkill(RemoveSkill event, Emitter<AppState> emit) {
    final skill = event.arguments as DropListModel;
    selectedSkills.remove(skill);
    skills.add(skill);
    emit(Done());
  }

  void _onRemoveKeyword(RemoveKeywords event, Emitter<AppState> emit) {
    final keyword = event.arguments as DropListModel;
    selectedKeywords.remove(keyword);
    keywords.add(keyword);
    emit(Done());
  }

  void _onToggleSkillsExpanded(ExpandSkills event, Emitter<AppState> emit) {
    expandSkills = !expandSkills;
    if (expandKeywords) {
      expandKeywords = false;
    }
    emit(Done());
  }

  void _onToggleKeywordsExpanded(ExpandKeywords event, Emitter<AppState> emit) {
    expandKeywords = !expandKeywords;
    if (expandSkills) {
      expandSkills = false;
    }
    emit(Done());
  }

  void reset() {
    selectedSkills.clear();
    expandSkills = false;
    selectedKeywords.clear();
    expandKeywords = false;
    expectedSalaryFromController.clear();
    expectedSalaryToController.clear();
    experienceToController.clear();
    experienceFromController.clear();
    currencyController.clear();
    locationController.clear();
    applicationDateController.clear();
    compatibilityRateController.clear();
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
