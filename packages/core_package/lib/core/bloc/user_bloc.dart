import 'package:core_package/core/utility/export.dart';

class UserBloc extends Bloc<AppEvent, AppState> {
  UserModel? _model;

  UserModel? get userModel => _model;

  UserBloc() : super(Start()) {
    on<Click>(onClick);
    on<Update>(onUpdate);
  }

  static UserBloc get instance =>
      BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  // static List<String> activeSystems = [];
  static List<ActiveSystemEnum> activeSystems = [];

  Future<void> onClick(AppEvent event, Emitter emit) async {
    emit(Loading());
    try {
      // UserModel sharedModel = await SharedHelper.sharedHelper!.getUser();
      UserModel sharedModel = await SecureStorageHelper.secureStorageHelper!.getUser();
      _model = sharedModel;
      emit(Done(model: sharedModel));
    } catch (e) {
      emit(Error());
    }
  }

  Future<void> onUpdate(AppEvent event, Emitter emit) async {
    emit(Loading());
    try {
      // UserModel sharedModel = await SharedHelper.sharedHelper!.getUser();
      UserModel sharedModel = await SecureStorageHelper.secureStorageHelper!.getUser();
      _model = sharedModel;
      emit(Done(model: sharedModel, reload: false));
    } catch (e) {
      emit(Error());
    }
  }
}
