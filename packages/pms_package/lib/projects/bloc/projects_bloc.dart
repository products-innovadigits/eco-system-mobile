
import 'package:pms_package/shared/pms_exports.dart';

class ProjectsBloc extends Bloc<AppEvent, AppState> {
  ProjectsBloc() : super(Start()) {
    scrollController = ScrollController();
    searchTEC = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getObjectives);
  }

  late SearchEngine _engine;
  final List<Widget> _cards = [];

  late ScrollController scrollController;
  TextEditingController? searchTEC;

  final filter = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateFilter => filter.sink.add;
  Stream<CustomFieldModel?> get filterStream =>
      filter.stream.asBroadcastStream();

  final goingDown = BehaviorSubject<bool>();
  Function(bool) get updateGoingDown => goingDown.sink.add;
  Stream<bool> get goingDownStream => goingDown.stream.asBroadcastStream();

  customScroll(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        updateGoingDown(false);
      } else {
        updateGoingDown(true);
      }
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage);
        add(Click(arguments: _engine));
      }
    });
  }

  _getObjectives(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      _engine = event.arguments as SearchEngine;
      if (_engine.currentPage == 0) {
        _cards.clear();
        emit(Loading());
      } else {
        emit(Done(cards: _cards, loading: true));
      }

      _engine.query = {
        "searchKeyword": searchTEC?.text.trim(),
        "periortyLevelId": filter.valueOrNull?.id,
        "pageIndex": _engine.currentPage + 1,
        "pageSize": _engine.limit,
      };

      ProjectsModel res = await ProjectsRepo.getProjects(_engine);

      if (res.data != null&&res.data!.isNotEmpty) {
        for (var objective in res.data ?? []) {
          _cards.add(ProjectCard(project: objective));
        }
        _engine.currentPage += 1;
        _engine.maxPages += 1;
        // _engine.updateCurrentPage(res.meta!.currPage!);
      }
      if (_cards.isNotEmpty) {
        emit(Done(cards: _cards));
      } else {
        emit(Empty());
      }
    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }
}
