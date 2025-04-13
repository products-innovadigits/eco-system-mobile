import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:geolocator/geolocator.dart';
import '../../bloc/user_bloc.dart';
import '../../helpers/permissions.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      ///Ask Notification Permission
      PermissionHandler.checkNotificationsPermission();

      ///Ask Location Permission
      Geolocator.requestPermission();

      SharedHelper helper = SharedHelper();
      bool? isLogin = await helper.readBoolean(CachingKey.IS_LOGIN);
      bool? skip = await helper.readBoolean(CachingKey.SKIP);

      ///Get Setting
      if (isLogin) {
        UserBloc.instance.add(Click());
      }

      // if (!skip && !isLogin) {
      //   CustomNavigator.push(Routes.BOARDING, clean: true);
      // } else
      if (!isLogin) {
        CustomNavigator.push(Routes.LOGIN, clean: true);
      } else {
        CustomNavigator.push(Routes.MAIN_PAGE, clean: true, arguments: 0);
      }
    });
  }
}
