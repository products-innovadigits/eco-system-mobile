import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/features/ats/repo/filtration_repo.dart';
import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/utility/export.dart';

class FiltrationBloc extends Bloc<AppEvent, AppState> {
  FiltrationBloc() : super(Start()) {
    on<PickSkill>(_onAddSkill);
    on<Click>(_getTags);
    on<PickTag>(_onAddTag);
    on<RemoveSkill>(_onRemoveSkill);
    on<RemoveKeywords>(_onRemoveTag);
    on<Expand>(_onToggleTagsExpansion);

    // Setup text controller listeners
    _setupTextControllerListeners();
  }

  // Controllers for text input fields
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

  // BehaviorSubject for filter state
  final _filterSubject = BehaviorSubject<CandidateFilterModel>.seeded(
      const CandidateFilterModel());

  Stream<CandidateFilterModel> get filterStream => _filterSubject.stream;

  CandidateFilterModel get filterModel => _filterSubject.value;

  Function(CandidateFilterModel) get updateFilter => _filterSubject.sink.add;

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

  void _setupTextControllerListeners() {
    // Listen to salary-related controllers
    expectedSalaryFromController.addListener(_updateSalaryFilters);
    expectedSalaryToController.addListener(_updateSalaryFilters);
    currencyController.addListener(_updateSalaryFilters);

    // Listen to experience-related controllers
    experienceFromController.addListener(_updateExperienceFilters);
    experienceToController.addListener(_updateExperienceFilters);

    // Listen to other controllers
    locationController.addListener(_updateLocationFilter);
    applicationDateController.addListener(_updateApplicationDateFilter);
    compatibilityRateController.addListener(_updateCompatibilityRateFilter);
  }

  void _updateSalaryFilters() {
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      expectedSalaryFrom: expectedSalaryFromController.text,
      expectedSalaryTo: expectedSalaryToController.text,
      currency: currencyController.text,
    ));
  }

  void _updateExperienceFilters() {
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      experienceFrom: experienceFromController.text,
      experienceTo: experienceToController.text,
    ));
  }

  void _updateLocationFilter() {
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      location: locationController.text,
    ));
  }

  void _updateApplicationDateFilter() {
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      applicationDate: applicationDateController.text,
    ));
  }

  void _updateCompatibilityRateFilter() {
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      compatibilityRate: compatibilityRateController.text,
    ));
  }

  void _onAddSkill(PickSkill event, Emitter<AppState> emit) {
    final skill = event.arguments as DropListModel;
    if (!filterModel.selectedSkills.contains(skill) &&
        skillController.text.isNotEmpty) {
      final currentModel = _filterSubject.value;
      updateFilter(currentModel.copyWith(
        selectedSkills: [...currentModel.selectedSkills, skill],
      ));
      skillController.clear();
      emit(Done());
    }
  }

  void _onAddTag(PickTag event, Emitter<AppState> emit) {
    final tag = event.arguments as DropListModel;
    if (!filterModel.selectedTags.contains(tag)) {
      final currentModel = _filterSubject.value;
      updateFilter(currentModel.copyWith(
        selectedTags: [...currentModel.selectedTags, tag],
        expandTags: false,
      ));
      tagsList.remove(tag);
      emit(Done());
    }
  }

  void _onRemoveSkill(RemoveSkill event, Emitter<AppState> emit) {
    final skill = event.arguments as DropListModel;
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      selectedSkills:
          currentModel.selectedSkills.where((s) => s != skill).toList(),
    ));
    emit(Done());
  }

  void _onRemoveTag(RemoveKeywords event, Emitter<AppState> emit) {
    final tag = event.arguments as DropListModel;
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      selectedTags: currentModel.selectedTags.where((t) => t != tag).toList(),
    ));
    tagsList.add(tag);
    emit(Done());
  }

  void _onToggleTagsExpansion(Expand event, Emitter<AppState> emit) {
    final currentModel = _filterSubject.value;
    updateFilter(currentModel.copyWith(
      expandTags: !currentModel.expandTags,
    ));
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

  bool validateFilters() {
    final errors = filterModel.validate();
    if (errors.isNotEmpty) {
      AppCore.errorToastMessage(errors.first);
      return false;
    }
    return true;
  }

  void collapseExpandedLists() {
    final currentModel = _filterSubject.value;
    if (currentModel.expandTags) {
      updateFilter(currentModel.copyWith(expandTags: false));
    }
  }

  void reset() {
    final selectedTags = filterModel.selectedTags;
    updateFilter(const CandidateFilterModel());
    tagsList.addAll(selectedTags);

    // Clear all controllers
    expectedSalaryFromController.clear();
    expectedSalaryToController.clear();
    experienceToController.clear();
    experienceFromController.clear();
    currencyController.clear();
    locationController.clear();
    applicationDateController.clear();
    compatibilityRateController.clear();
    skillController.clear();

    // Reset all active fields
    updateFilter(filterModel.copyWith(
      selectedSkills: [],
      selectedTags: [],
      expectedSalaryFrom: null,
      expectedSalaryTo: null,
      currency: null,
      experienceFrom: null,
      experienceTo: null,
      location: null,
      applicationDate: null,
      compatibilityRate: null,
      expandTags: false,
    ));
  }

  void applyFilters(
      {TalentPoolBloc? talentBloc, CandidatesBloc? candidatesBloc}) {
    if (!validateFilters()) {
      return;
    }

    if (talentBloc != null)
      talentBloc.add(ApplyFilters(arguments: {
        "skills": filterModel.selectedSkills,
        "tags": filterModel.selectedTags
      }));
    if (candidatesBloc != null)
      candidatesBloc.add(ApplyFilters(arguments: {
        "skills": filterModel.selectedSkills,
        "tags": filterModel.selectedTags
      }));
    collapseExpandedLists();
    CustomNavigator.pop();
  }

  void resetFilters(
      {TalentPoolBloc? talentBloc, CandidatesBloc? candidatesBloc}) {
    if (talentBloc != null) talentBloc.add(Reset());
    if (candidatesBloc != null) candidatesBloc.add(Reset());
    reset();
    CustomNavigator.pop();
  }

  @override
  Future<void> close() {
    _filterSubject.close();

    // Remove listeners
    expectedSalaryFromController.removeListener(_updateSalaryFilters);
    expectedSalaryToController.removeListener(_updateSalaryFilters);
    currencyController.removeListener(_updateSalaryFilters);
    experienceFromController.removeListener(_updateExperienceFilters);
    experienceToController.removeListener(_updateExperienceFilters);
    locationController.removeListener(_updateLocationFilter);
    applicationDateController.removeListener(_updateApplicationDateFilter);
    compatibilityRateController.removeListener(_updateCompatibilityRateFilter);

    // Dispose controllers
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
