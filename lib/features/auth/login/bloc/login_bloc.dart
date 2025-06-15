import 'package:dio/dio.dart';
import 'package:eco_system/bloc/user_bloc.dart';
import 'package:eco_system/core/app_core.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/auth/login/model/user_model.dart';
import 'package:eco_system/features/auth/login/repo/login_repo.dart';
import 'package:eco_system/helpers/secure_storage_helper.dart';
import 'package:eco_system/helpers/shared_helper.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/translation/all_translation.dart';

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
        CustomNavigator.push(Routes.MAIN_PAGE, clean: true, arguments: 0);
        AppCore.successMessage(
            allTranslations.text('you_logged_in_successfully'));
        emit(Done());
        Future.delayed(const Duration(seconds: 1), () => clear());
      } else {
        AppCore.errorMessage(allTranslations.text('invalid_credentials'));
        emit(Start());
      }
    } catch (e) {
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
