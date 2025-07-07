import 'package:core_package/core/utility/export.dart';
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

  clear() {
    mailTEC.clear();
    passwordTEC.clear();
  }

  Future<void> onClick(AppEvent event, Emitter emit) async {
    emit(Loading());
    try {
      Response res = await LoginRepo.login(
        password: passwordTEC.text.trim(),
        username: mailTEC.text.trim(),
      );
      if (res.statusCode == 200) {
        UserModel model = UserModel.fromJson(res.data['data']);
        await SecureStorageHelper.secureStorageHelper!
            .saveUser(model)
            .then((v) {
          UserBloc.instance.add(Click());
        });
        await SharedHelper.sharedHelper!.saveUser();
        CustomNavigator.push(Routes.MAIN_PAGE,
            clean: true,
            arguments:
                MainPageArgs(index: 0, systems: UserBloc.activeSystems));
        AppCore.successMessage(
            allTranslations.text('you_logged_in_successfully'));
        emit(Done());
        Future.delayed(const Duration(seconds: 1), () => clear());
      } else {
        AppCore.errorMessage(allTranslations.text('invalid_credentials'));
        emit(Start());
      }
    } catch (e) {
      cprint('Something went wrong: $e');
      AppCore.errorMessage(allTranslations.text('invalid_credentials'));
      emit(Error());
    }
  }

  Future<void> onRemember(Remember event, Emitter<AppState> emit) async {
    Map<String, dynamic>? data = await SharedHelper.sharedHelper!.remember();
    if (data != '{}') {
      passwordTEC.text = data['password'] ?? '';
      mailTEC.text = data['email'] ?? '';
      updateRememberMe(data['email'] != '' && data['email'] != null);
      emit(Done());
    }
  }
}
