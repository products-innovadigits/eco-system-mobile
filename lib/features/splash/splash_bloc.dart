import 'package:core_system/core/bloc/theme_cubit.dart';
import 'package:core_system/core/helpers/permissions.dart';
import 'package:core_system/core/utility/export.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  SplashBloc() : super(Start()) {
    on<Click>(onClick);
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
      bool? isLogin = await helper.readBoolean(CachingKey.isLogin);
      bool? skip = await helper.readBoolean(CachingKey.skipBoarding);

      if (isLogin) {
        /// Brings back the system chosen at login. Only meaningful for a
        /// signed-in session — a fresh install falls back to the first enabled
        /// module until [LoginBloc] records a real choice.
        await ActiveSystem.restore();
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
