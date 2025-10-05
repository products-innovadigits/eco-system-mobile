import 'package:pms_system/shared/pms_exports.dart';

class StageDocsBloc extends Bloc<AppEvent, AppState> {
  StageDocsBloc() : super(Start()) {
    on<Click>(_onAddComment);
  }

  TextEditingController commentCtrl = TextEditingController();

  void _onAddComment(AppEvent event, Emitter<AppState> emit) {
    commentCtrl.clear();
    emit(Done());
  }
}
