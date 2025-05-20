import 'package:eco_system/utility/export.dart';

class CandidatesBloc extends Bloc<AppEvent, AppState> {
  CandidatesBloc() : super(Start()) {
    on<InitCandidates>(_onInitCandidates);
    on<Click>(_onClick);
  }

  final ScrollController scrollController = ScrollController();
  String jobTitle = '';
  int candidateCount = 0;

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

  void _onClick(AppEvent event, Emitter<AppState> emit) async {
    emit(Done());
  }
}
