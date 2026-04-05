import 'package:core_system/core/utility/export.dart';

class SettingsBloc extends Bloc<AppEvent, AppState> {
  SettingsBloc() : super(Start()) {
    on<Click>(_onClick);
  }

  Future<void> _onClick(Click event, Emitter<AppState> emit) async {
    final action = event.arguments as String?;
    try {
      switch (action) {
        case 'employees':
          CustomNavigator.push(Routes.EMPLOYEES_PERFORMANCE);
          emit(Done());
          return;
        case 'logout':
          emit(Loading());
          await SharedHelper.sharedHelper!.logout();
          emit(Done());
          return;
        default:
          emit(Done());
      }
    } catch (_) {
      emit(Error());
    }
  }
}
