import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';
import 'package:eco_system/features/auth/login/repo/login_repo.dart';

enum LoginSystemPickMode { allEnabled, customize }

/// Prototype login: only this email/password pair is accepted.
const String kPrototypeLoginEmail = 'nawah@innovadigits.com';
const String kPrototypeLoginPassword = '12345678';

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

  final systemPickMode = BehaviorSubject<LoginSystemPickMode>.seeded(
    LoginSystemPickMode.allEnabled,
  );

  /// Selected module ids when [LoginSystemPickMode.customize] (subset of enabled modules).
  final customizedModuleIds = BehaviorSubject<Set<String>>.seeded({});

  void setSystemPickMode(LoginSystemPickMode mode) {
    systemPickMode.add(mode);
    if (mode == LoginSystemPickMode.allEnabled) {
      customizedModuleIds.add({});
    }
  }

  void setCustomizedModuleIds(Set<String> ids) {
    customizedModuleIds.add(Set<String>.from(ids));
  }

  List<SystemModule> get _enabled => ModulesRegistry.enabledModules;

  void applyAllEnabledSystems() {
    final modules = _enabled;
    if (modules.isEmpty) return;
    UserBloc.activeSystems = modules.map((m) => m.system).toList();
    selectedSystemId = modules.first.id;
    AppConfig.activeSystem = modules.first.system;
    // null => shell shows "All systems" in [SystemSelectionWidget]
    UserBloc.currentActiveSystem = null;
  }

  void applyCustomizedSystems() {
    final ids = customizedModuleIds.value;
    final modules = _enabled.where((m) => ids.contains(m.id)).toList();
    if (modules.isEmpty) return;
    UserBloc.activeSystems = modules.map((m) => m.system).toList();

    if (modules.length > 1) {
      selectedSystemId = modules.first.id;
      AppConfig.activeSystem = modules.first.system;
      UserBloc.currentActiveSystem = null;
    } else {
      final mod = modules.first;
      selectedSystemId = mod.id;
      AppConfig.activeSystem = mod.system;
      UserBloc.currentActiveSystem = mod.system;
    }
  }

  String? selectedSystemId;

  /// Returns false after showing an error (system selection).
  bool _validateSystemSelection() {
    final mode = systemPickMode.value;
    if (mode == LoginSystemPickMode.allEnabled) {
      if (_enabled.isEmpty) {
        AppCore.errorMessage(allTranslations.text('please_select_system'));
        return false;
      }
      return true;
    }
    final ids = customizedModuleIds.value;
    if (ids.isEmpty) {
      AppCore.errorMessage(
        allTranslations.text(LocaleKeys.login_select_systems_first),
      );
      return false;
    }
    final modules = _enabled.where((m) => ids.contains(m.id)).toList();
    if (modules.isEmpty) {
      AppCore.errorMessage(allTranslations.text('please_select_system'));
      return false;
    }
    return true;
  }

  /// Returns false after showing [invalid_credentials] if email/password mismatch.
  bool _validatePrototypeCredentials() {
    final email = mailTEC.text.trim();
    final password = passwordTEC.text.trim();
    if (email.toLowerCase() != kPrototypeLoginEmail.toLowerCase() ||
        password != kPrototypeLoginPassword) {
      AppCore.errorMessage(allTranslations.text('invalid_credentials'));
      return false;
    }
    return true;
  }

  void setSelectedSystem(String systemId) {
    selectedSystemId = systemId;
    AppConfig.activeSystem = ActiveSystemEnum.fromModuleId(systemId);
  }

  void clear() {
    mailTEC.clear();
    passwordTEC.clear();
  }

  Future<void> onClick(AppEvent event, Emitter emit) async {
    if (!_validateSystemSelection()) return;
    if (!_validatePrototypeCredentials()) return;

    final mode = systemPickMode.value;
    late final ActiveSystemEnum systemForLogin;

    if (mode == LoginSystemPickMode.allEnabled) {
      systemForLogin = _enabled.first.system;
    } else {
      final modules = _enabled
          .where((m) => customizedModuleIds.value.contains(m.id))
          .toList();
      systemForLogin = modules.first.system;
    }

    emit(Loading());
    try {
      final result = await LoginRepo.login(
        password: passwordTEC.text.trim(),
        username: mailTEC.text.trim(),
        systemTypeEnum: systemForLogin,
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
        if (mode == LoginSystemPickMode.allEnabled) {
          applyAllEnabledSystems();
        } else {
          applyCustomizedSystems();
        }

        UserModel model = UserModel.fromJson(res.data['data']);
        await SecureStorageHelper.secureStorageHelper!.saveUser(
          model,
          token: systemForLogin == ActiveSystemEnum.pms
              ? model.token
              : model.accessToken,
        );
        await SharedHelper.sharedHelper!.saveUser();

        if (mode == LoginSystemPickMode.allEnabled) {
          SharedHelper.sharedHelper!.removeData(
            CachingKey.allowedSystemModuleIds,
          );
          await SharedHelper.sharedHelper!.writeData(
            CachingKey.chosenSystemModuleId,
            SystemHelper.allSystemsUiModuleId,
          );
        } else {
          final idList = customizedModuleIds.value.toList()..sort();
          await SharedHelper.sharedHelper!.writeData(
            CachingKey.allowedSystemModuleIds,
            jsonEncode(idList),
          );
          final modules = _enabled
              .where((m) => customizedModuleIds.value.contains(m.id))
              .toList();
          final chosen = modules.length > 1
              ? SystemHelper.allSystemsUiModuleId
              : modules.first.id;
          await SharedHelper.sharedHelper!.writeData(
            CachingKey.chosenSystemModuleId,
            chosen,
          );
        }

        // Re-assert right before navigation so the value is guaranteed
        // even if something above mutated the static field.
        if (mode == LoginSystemPickMode.allEnabled) {
          UserBloc.currentActiveSystem = null;
        }

        CustomNavigator.push(Routes.MAIN_PAGE, clean: true);

        // Trigger UserBloc AFTER navigation so the new BlocBuilder in
        // MainHeader receives a fresh emission and rebuilds.
        UserBloc.instance.add(Click());

        AppCore.successMessage(
          allTranslations.text('you_logged_in_successfully'),
        );
        clear();
        emit(Done());
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
    systemPickMode.close();
    customizedModuleIds.close();
    return super.close();
  }
}
