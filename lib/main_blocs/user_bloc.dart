import 'package:eco_system/features/login/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/navigation/custom_navigation.dart';

class UserBloc extends Bloc<AppEvent, AppState> {

  UserModel? _model;

  UserModel? get user => _model;

  UserBloc() : super(Start());

  static UserBloc get instance=>BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    yield Loading();
    if (event is Click) {
      UserModel _sharedModel = await SharedHelper.sharedHelper!.getUser();
      _model = _sharedModel;
      yield Done(model: _sharedModel);
    }else if(event is Update){
      UserModel _sharedModel = await SharedHelper.sharedHelper!.getUser();
      _model = _sharedModel;
      yield Done(model: _sharedModel ,reload: false );
    }
  }
}

