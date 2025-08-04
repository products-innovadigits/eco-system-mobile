import 'package:core_system/core/helpers/permissions.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:geolocator/geolocator.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    /// Selected Systems from GitHub Actions
    const String selectedSystems = String.fromEnvironment(
      'ACTIVE_SYSTEMS',
      defaultValue: 'strategy,ats,pms',
    );
    final List<ActiveSystemEnum> activeSystems = selectedSystems
        .split(',')
        .map((s) => ActiveSystemEnum.fromString(s))
        .toList();
    cprint('====Systems====:${activeSystems.map((e) => e.value).toList()}');
    Future.delayed(const Duration(milliseconds: 3000), () async {
      ///Ask Notification Permission
      PermissionHandler.checkNotificationsPermission();

      ///Ask Location Permission
      Geolocator.requestPermission();

      SharedHelper helper = SharedHelper();
      bool? isLogin = await helper.readBoolean(CachingKey.IS_LOGIN);
      // bool? skip = await helper.readBoolean(CachingKey.SKIP);

      ///Get Setting
      UserBloc.activeSystems = activeSystems;

      if (isLogin) {
        UserBloc.instance.add(Click());
      }

      // if (!skip && !isLogin) {
      //   CustomNavigator.push(Routes.BOARDING, clean: true);
      // } else
      if (!isLogin) {
        CustomNavigator.push(Routes.LOGIN, clean: true);
      } else {
        CustomNavigator.push(Routes.MAIN_PAGE, clean: true);
      }
    });
  }
}
