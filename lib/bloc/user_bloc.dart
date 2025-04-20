import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/auth/login/model/user_model.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<AppEvent, AppState> {
  UserModel? _model;

  UserModel? get user => _model;

  UserBloc() : super(Start()) {
    on<Click>(onClick);
    on<Update>(onUpdate);
  }

  static UserBloc get instance =>
      BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  Future<void> onClick(AppEvent event, Emitter emit) async {
    emit(Loading());
    try {
      UserModel sharedModel = await SharedHelper.sharedHelper!.getUser();
      _model = sharedModel;
      emit(Done(model: sharedModel));
    } catch (e) {
      emit(Error());
    }
  }

  Future<void> onUpdate(AppEvent event, Emitter emit) async {
    emit(Loading());
    try {
      UserModel sharedModel = await SharedHelper.sharedHelper!.getUser();
      _model = sharedModel;
      emit(Done(model: sharedModel, reload: false));
    } catch (e) {
      emit(Error());
    }
  }
}
