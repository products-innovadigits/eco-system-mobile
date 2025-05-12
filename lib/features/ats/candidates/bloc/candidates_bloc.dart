import 'package:eco_system/components/custom_drop_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_event.dart';
import '../../../../core/app_state.dart';

class CandidatesBloc extends Bloc<AppEvent, AppState> {
  CandidatesBloc() : super(Start()) {
    on<InitCandidates>(_onInitCandidates);
    on<PickSkill>(_onAddSkill);
    on<PickKeyword>(_onAddKeyword);
    on<RemoveSkill>(_onRemoveSkill);
    on<RemoveKeywords>(_onRemoveKeyword);
    on<ExpandSkills>(_onToggleSkillsExpanded);
    on<ExpandKeywords>(_onToggleKeywordsExpanded);
    on<Click>(_onClick);
  }

  final ScrollController scrollController = ScrollController();
  final TextEditingController expectedSalaryFromController =
      TextEditingController();
  final TextEditingController expectedSalaryToController =
      TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController experienceToController = TextEditingController();
  final TextEditingController experienceFromController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
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
  ];
  final List<DropListModel> currencies = [
    DropListModel(id: 1, name: 'ر.س'),
    DropListModel(id: 2, name: 'ج.م'),
  ];
  final List<DropListModel> genders = [
    DropListModel(id: 1, name: 'ذكر'),
    DropListModel(id: 2, name: 'انثى'),
  ];

  final List<DropListModel> qualified = [
    DropListModel(id: 1, name: 'مؤهل'),
    DropListModel(id: 2, name: 'غير مؤهل'),
  ];

  List<DropListModel> selectedSkills = [];
  List<DropListModel> selectedKeywords = [];

  final Map<String, GlobalKey> stageKeys = {
    'المرحلة التطبيقية': GlobalKey(),
    'مرحلة المقابلة الهاتفية': GlobalKey(),
    'مرحلة التقييم': GlobalKey(),
    'مرحلة المقابلة': GlobalKey(),
    'مرحلة العرض': GlobalKey(),
    'مرحلة التوظيف': GlobalKey(),
  };

  List<String> get stages => stageKeys.keys.toList();

  Map<String, GlobalKey> get keys => stageKeys;

  void scrollToStage(String stage) {
    final key = stageKeys[stage];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  void _onInitCandidates(InitCandidates event, Emitter<AppState> emit) {
    emit(Done(data: event.arguments as String));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToStage(event.arguments as String);
    });
  }

  void _onClick(AppEvent event, Emitter<AppState> emit) async {
    emit(Done());
  }

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
  }

  @override
  Future<void> close() {
    experienceToController.dispose();
    experienceFromController.dispose();
    expectedSalaryFromController.dispose();
    expectedSalaryToController.dispose();
    currencyController.dispose();
    locationController.dispose();
    return super.close();
  }
}
