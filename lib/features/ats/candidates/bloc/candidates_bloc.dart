import 'package:eco_system/utility/export.dart';

class CandidatesBloc extends Bloc<AppEvent, AppState> {
  CandidatesBloc() : super(Start()) {
    on<InitCandidates>(_onInitCandidates);
    on<Click>(_getCandidates);
    on<ApplyFilters>(_onApplyFilters);
    on<Reset>(_onResetFilters);
  }

  final ScrollController scrollController = ScrollController();
  List<CandidateModel> candidatesList = [];
  late SearchEngine _engine;
  String jobTitle = '';
  int candidateCount = 0;
  List<String> selectedSkills = [];
  List<String> selectedTags = [];
  bool isFiltered = false;

  final Map<StageModel, GlobalKey> _stageKeys = {};

  List<StageModel> get stages => _stageKeys.keys.toList();

  Map<StageModel, GlobalKey> get keys => _stageKeys;

  void scrollToStage(String targetStage) {
    final match = _stageKeys.keys.firstWhere(
      (s) => s.type == targetStage,
      orElse: () => StageModel(),
    );
    final key = _stageKeys[match];

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
    _stageKeys.clear();
    for (final stage in event.stages ?? []) {
      _stageKeys[stage] = GlobalKey();
    }
    jobTitle = event.jobTitle ?? '';
    candidateCount = event.stages?.fold(
          0,
          (sum, stage) => sum! + (stage.count ?? 0),
        ) ??
        0;
    emit(Done(data: event.targetStage));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (event.targetStage != null) scrollToStage(event.targetStage!);
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
    _engine = SearchEngine();
    candidatesList.clear();
    add(Click(arguments: _engine));
  }

  void _onResetFilters(Reset event, Emitter<AppState> emit) {
    selectedSkills.clear();
    selectedTags.clear();
    isFiltered = false;
    _engine = SearchEngine();
    candidatesList.clear();
    add(Click(arguments: _engine));
  }

  void _getCandidates(AppEvent event, Emitter<AppState> emit) async {
    try {
      _engine = event.arguments as SearchEngine;

      if (_engine.currentPage == 0) {
        candidatesList.clear();
        emit(Loading());
      } else {
        emit(Done(loading: true));
      }

      final newTalents = await TalentPoolService.getTalents(
        engine: _engine,
        skills: selectedSkills,
        tags: selectedTags,
      );
      candidatesList.addAll(newTalents);

      if (candidatesList.isNotEmpty) {
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
    _stageKeys.clear();
    candidatesList.clear();
    selectedSkills.clear();
    selectedTags.clear();
    isFiltered = false;
    _engine = SearchEngine();
    return super.close();
  }
}
