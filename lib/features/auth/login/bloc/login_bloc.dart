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

  /// Module id of the system being signed in to. The picker that used to set
  /// this is hidden on the demo instance — every enabled system shares one
  /// backend, so the first enabled module authenticates all of them and the
  /// in-app switcher moves between them afterwards.
  ///
  /// Restore the `CustomDropList` in `login.dart` to let the user choose again.
  String? selectedSystemId = ActiveSystem.modules.isNotEmpty
      ? ActiveSystem.modules.first.id
      : null;

  // Kept for when the login-time system picker comes back.
  // void setSelectedSystem(String systemId) => selectedSystemId = systemId;

  /// The system the credentials are checked against, resolved from
  /// [selectedSystemId] rather than from global state — nothing is recorded
  /// until the login actually succeeds.
  ActiveSystemEnum? get _selectedSystem =>
      selectedSystemId == null
      ? null
      : ActiveSystem.moduleById(selectedSystemId!)?.system;

  void clear() {
    mailTEC.clear();
    passwordTEC.clear();
  }

  Future<void> onClick(AppEvent event, Emitter emit) async {
    final system = _selectedSystem;
    if (system == null) {
      AppCore.errorMessage(allTranslations.text('please_select_system'));
      return;
    }
    emit(Loading());
    try {
      final result = await LoginRepo.login(
        password: passwordTEC.text.trim(),
        username: mailTEC.text.trim(),
        systemTypeEnum: system,
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
      final statusCode = res.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        /// PMS wraps the payload in `data`, but not every endpoint does.
        final payload = res.data is Map && res.data['data'] is Map
            ? Map<String, dynamic>.from(res.data['data'])
            : Map<String, dynamic>.from(res.data as Map);
        UserModel model = UserModel.fromJson(payload);
        final token = system == ActiveSystemEnum.pms
            ? model.token
            : model.accessToken;
        if (token == null || token.isEmpty) {
          AppCore.errorMessage(allTranslations.text('invalid_credentials'));
          emit(Start());
          return;
        }
        await SecureStorageHelper.secureStorageHelper!
            .saveUser(model, token: token)
            .then((v) {
              UserBloc.instance.add(Click());
            });
        await SharedHelper.sharedHelper!.saveUser();

        /// Records the system this session is authenticated against and makes
        /// it the one being browsed. Persisted, so a cold start comes back to
        /// the same place via `ActiveSystem.restore()`.
        await ActiveSystem.signIn(system);
        // Only needed when Strategy is on a separate backend from the system
        // that issued the token. It shares one today, so the token carries over.
        // if (ActiveSystem.available.contains(ActiveSystemEnum.strategy)) {
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
