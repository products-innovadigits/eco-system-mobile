import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';


class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start());

 static SplashBloc get instance => BlocProvider.of(CustomNavigator.navigatorState.currentContext!);

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if(event is Click){
      SharedHelper helper = SharedHelper();
      bool? isLogin = await helper.readBoolean(CachingKey.IS_LOGIN);
      bool? skip = await helper.readBoolean(CachingKey.SKIP);
      // if(isLogin)
      //   CustomNavigator.push(Routes.MAIN_PAGE, clean: true);
      // else
      //   CustomNavigator.push(Routes.BOARDING, clean: true);

    }
  }
}
