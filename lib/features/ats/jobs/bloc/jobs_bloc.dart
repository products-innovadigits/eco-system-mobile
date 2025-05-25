import 'package:eco_system/features/ats/jobs/model/jobs_model.dart';
import 'package:eco_system/features/ats/jobs/repo/jobs_repo.dart';
import 'package:eco_system/utility/export.dart';

class JobsBloc extends Bloc<AppEvent, AppState> {
  JobsBloc() : super(Start()) {
    scrollController = ScrollController();
    customScroll(scrollController);
    on<Click>(_getJobs);
    on<Expand>(onExpand);
    on<Select>(_onSelectJob);
  }

  List<JobDataModel> jobsList = [];
  late SearchEngine _engine;
  late ScrollController scrollController;

  final _expandedIndex = BehaviorSubject<int?>.seeded(-1);

  Function(int?) get updateExpandedIndex => _expandedIndex.sink.add;

  Stream<int?> get updateExpandedStream =>
      _expandedIndex.stream.asBroadcastStream();

  List<int> selectedJobsList = [];

  Future<void> onExpand(Expand event, Emitter<AppState> emit) async {
    int index = event.arguments as int;
    if (_expandedIndex.value == index) {
      updateExpandedIndex(-1);
    } else {
      updateExpandedIndex(index);
    }
    emit(Done());
  }

  void _onSelectJob(Select event, Emitter<AppState> emit) {
    int jobId = event.arguments as int;
    if (event.arguments != null) {
      if (selectedJobsList.contains(jobId)) {
        selectedJobsList.remove(jobId);
      } else {
        selectedJobsList.add(jobId);
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

      _engine.query = {
        "pageIndex": _engine.currentPage + 1,
        "pageSize": _engine.limit,
      };

      final res = await JobsRepo.getJobs(_engine);

      if (res.data != null && res.data!.isNotEmpty) {
        for (var job in res.data!) {
          jobsList.add(job);
        }
        _engine.currentPage += 1;
        _engine.maxPages += 1;
      }

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
    scrollController.dispose();
    _expandedIndex.close();
    selectedJobsList.clear();
    jobsList.clear();
    return super.close();
  }
}
