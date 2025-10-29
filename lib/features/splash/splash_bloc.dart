import 'package:core_system/core/bloc/theme_cubit.dart';
import 'package:core_system/core/helpers/permissions.dart';
import 'package:core_system/core/utility/export.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start()) {
    on<Click>(onClick);
  }

  void getActiveSystem() async {
    /// Selected Systems from CI/CD
    const String selectedSystems = String.fromEnvironment(
      'ACTIVE_SYSTEMS',
      defaultValue: 'strategy,ats,pms',
    );
    final List<ActiveSystemEnum> activeSystems = selectedSystems
        .split(',')
        .map((s) => ActiveSystemEnum.fromString(s))
        .toList();

    UserBloc.activeSystems = activeSystems;
  }

  Future<void> getColorScheme() async {
    ThemeCubit.instance.applyModel(ColorSchemeModel());
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    await getColorScheme();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      ///Ask Notification Permission
      PermissionHandler.checkNotificationsPermission();

      ///Ask Location Permission
      // Geolocator.requestPermission();

      SharedHelper helper = SharedHelper();
      bool? isLogin = await helper.readBoolean(CachingKey.IS_LOGIN);
      bool? skip = await helper.readBoolean(CachingKey.SKIP_BOARDING);

      ///Get Selected Active System
      getActiveSystem();

      if (isLogin) {
        UserBloc.instance.add(Click());
      }

      if (!skip) {
        CustomNavigator.push(Routes.INTRO, clean: true);
      } else if (!isLogin) {
        CustomNavigator.push(Routes.LOGIN, clean: true);
      } else {
        CustomNavigator.push(Routes.MAIN_PAGE, clean: true);
      }
    });
  }
}
