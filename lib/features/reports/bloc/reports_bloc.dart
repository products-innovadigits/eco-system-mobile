import 'package:core_package/core/utility/export.dart';
import 'package:eco_system/features/reports/model/report_model.dart';
import 'package:eco_system/features/reports/repo/reports_repo.dart';
import 'package:eco_system/features/reports/widgets/report_card_widget.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ReportsBloc extends Bloc<AppEvent, AppState> {
  ReportsBloc() : super(Start()) {
    scrollController = ScrollController();
    searchTEC = TextEditingController();
    customScroll(scrollController);
    on<Click>(_getReports);
  }



  final List<ReportData> reports = [
    ReportData(
      id: '1',
      title: 'تقرير الأداء للربع الأول pdf',
      date: 'اخر تعديل: Jan 15, 2025 - 10:30 AM',
      status: 'الأداء والتقييم',
    ),
    ReportData(
      id: '2',
      title: 'تقرير المبيعات للربع الثاني pdf',
      date: 'اخر تعديل: Jan 20, 2025 - 11:00 AM',
      status: 'المبيعات والإيرادات',
    ),
    ReportData(
      id: '3',
      title: 'تقرير التسويق للربع الثالث pdf',
      date: 'اخر تعديل: Jan 25, 2025 - 12:15 PM',
      status: 'التسويق والعروض الترويجية',
    ),
    ReportData(
      id: '4',
      title: 'تقرير الموارد البشرية للربع الرابع pdf',
      date: 'اخر تعديل: Jan 30, 2025 - 01:45 PM',
      status: 'الموارد البشرية والتوظيف',
    ),
    ReportData(
      id: '5',
      title: 'تقرير المالية للربع الأول pdf',
      date: 'اخر تعديل: Feb 05, 2025 - 02:30 PM',
      status: 'المالية والمحاسبة',
    ),
  ];
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

  _getReports(AppEvent event, Emitter<AppState> emit) async {
    emit(Loading());
    try {
      // _engine = event.arguments as SearchEngine;
      // if (_engine.currentPage == 0) {
      //   _cards.clear();
      //   emit(Loading());
      // } else {
      //   emit(Done(cards: _cards, loading: true));
      // }
      //
      // _engine.query = {
      //   "searchKeyword": searchTEC?.text.trim(),
      //   "periortyLevelId": filter.valueOrNull?.id,
      //   "pageIndex": _engine.currentPage + 1,
      //   "pageSize": _engine.limit,
      // };
      //
      // ReportsModel res = await ReportsRepo.getReports(_engine);

      // if (res.data != null&&res.data!.isNotEmpty) {
      //   for (var report in res.data ?? []) {
      //     _cards.add(ReportCardWidget(reportData: report));
      //   }
      //   _engine.currentPage += 1;
      //   _engine.maxPages += 1;
      //   // _engine.updateCurrentPage(res.meta!.currPage!);
      // }
      await Future.delayed(Duration(seconds: 2) , (){
        if (reports.isNotEmpty) {
          for (var report in reports) {
            _cards.add(ReportCardWidget(reportData: report));
          }
          // _engine.currentPage += 1;
          // _engine.maxPages += 1;
          // _engine.updateCurrentPage(res.meta!.currPage!);
        }
        if (_cards.isNotEmpty) {
          emit(Done(cards: _cards));
        } else {
          emit(Empty());
        }
      });

    } catch (e) {
      AppCore.errorMessage(allTranslations.text('something_went_wrong'));

      emit(Error());
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    searchTEC?.dispose();
    return super.close();
  }
}
