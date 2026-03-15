import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/features/auth/login/repo/login_repo.dart';

class LoginBloc extends Bloc<AppEvent, AppState> {
  LoginBloc() : super(Start()) {
    on<Click>(onClick);
    updateRememberMe(false);
    on<Remember>(onRemember);
  }

  final rememberMe = BehaviorSubject<bool?>();

  Function(bool?) get updateRememberMe => rememberMe.sink.add;

  Stream<bool?> get rememberMeStream => rememberMe.stream.asBroadcastStream();

  final globalKey = GlobalKey<FormState>();

  TextEditingController mailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  String? selectedSystemId;

  void setSelectedSystem(String systemId) {
    selectedSystemId = systemId;
    AppConfig.activeSystem = ActiveSystemEnum.fromModuleId(systemId);
  }

  void clear() {
    mailTEC.clear();
    passwordTEC.clear();
  }

  Future<void> onClick(AppEvent event, Emitter emit) async {
    // if (selectedSystemId == null) {
    //   AppCore.errorMessage(allTranslations.text('please_select_system'));
    //   return;
    // }
    emit(Loading());
    try {
      final system = AppConfig.activeSystem;
      final result = await LoginRepo.login(
        password: passwordTEC.text.trim(),
        username: mailTEC.text.trim(),
        // systemTypeEnum: system,
      );
      if (result is! Response) {
        AppCore.errorMessage(
          result is String
              ? result
              : allTranslations.text('invalid_credentials'),
        );
        emit(Start());
        return;
      }
      final res = result;
      if (res.statusCode == 200) {
        UserModel model = UserModel.fromJson(res.data['data']);
        await SecureStorageHelper.secureStorageHelper!
            .saveUser(
              model,
              token:
                  // system == ActiveSystemEnum.pms
                  //     ? model.token
                  //     :
                  model.accessToken,
            )
            .then((v) {
              UserBloc.instance.add(Click());
            });
        await SharedHelper.sharedHelper!.saveUser();
        // if (UserBloc.activeSystems.contains(ActiveSystemEnum.strategy)) {
        //   log('Strategy system is active==================');
        //   await LoginRepo.strategyLogin(token: model.accessToken.toString());
        // }
        CustomNavigator.push(Routes.MAIN_PAGE, clean: true);
        AppCore.successMessage(
          allTranslations.text('you_logged_in_successfully'),
        );
        clear();
        emit(Done());
        // Future.delayed(const Duration(seconds: 1), () => clear());
      } else {
        AppCore.errorMessage(allTranslations.text('invalid_credentials'));
        emit(Start());
      }
    } catch (e) {
      AppCore.errorMessage(e.toString().replaceFirst('Exception: ', ''));
      emit(Start());
    }
  }

  Future<void> onRemember(Remember event, Emitter<AppState> emit) async {
    Map<String, dynamic>? data = await SharedHelper.sharedHelper!.remember();
    if (data.isNotEmpty) {
      passwordTEC.text = data['password'] ?? '';
      mailTEC.text = data['email'] ?? '';
      updateRememberMe(data['email'] != '' && data['email'] != null);
      emit(Done());
    }
  }

  @override
  Future<void> close() {
    mailTEC.dispose();
    passwordTEC.dispose();
    rememberMe.close();
    return super.close();
  }
}
