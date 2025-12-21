import 'package:pms_system/shared/pms_exports.dart';

class ProjectReportBloc extends Bloc<AppEvent, AppState> {
  ProjectReportBloc() : super(Start()) {
    on<Click>(_onClick);
  }

  _onClick(AppEvent event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Response res = await ProjectReportRepo.getProjectReport(
        event.arguments as int,
      );

      if (res.statusCode == 200 && res.data != null) {
        ProjectReportModel model = ProjectReportModel.fromJson(
          res.data,
        );
        emit(Done(model: model));
      } else {
        emit(Error());
      }
    } catch (e) {
      emit(Error());
    }
  }
}
