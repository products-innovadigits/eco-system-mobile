import 'package:ats_package/jobs/service/jobs_service.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class JobsBloc extends Bloc<AppEvent, AppState> {
  JobsBloc() : super(Start()) {
    scrollController = ScrollController();
    searchController = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getJobs);
    on<Expand>(onExpand);
    on<Select>(_onSelectJob);
  }

  List<JobDataModel> jobsList = [];
  late SearchEngine _engine;
  late ScrollController scrollController;
  late TextEditingController searchController;

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

  void onCancelSearch() {
    if (searchController.text.isNotEmpty) {
      add(Click(arguments: SearchEngine()));
    }
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

      final jobs = await JobsService.getJobs(engine: _engine);

      jobsList.addAll(jobs);

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
    searchController.dispose();
    return super.close();
  }
}

