import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/vaildator.dart';
import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_images.dart';
import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/features/login/widget/welcome_widget.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';

import '../bloc/login_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool showPassword = false;
  final FocusNode usernameNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  bool focusOnUsername = false;
  bool focusOnPassword = false;

  @override
  void initState() {
    usernameNode.addListener(() {
      focusOnUsername = usernameNode.hasFocus;
    });
    passwordNode.addListener(() {
      focusOnPassword = passwordNode.hasFocus;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            setState(() {
              focusOnUsername = false;
              focusOnPassword = false;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              SizedBox(
                height: MediaQueryHelper.height,
                child: Form(
                  key: _globalKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WelcomeWidget(),
                        ListAnimator(
                          verticalOffset: 50.0,
                          horizontalOffset: 0.0,
                          scroll: false,
                          data: [
                            Column(
                              children: [
                                StreamBuilder<String?>(
                                    stream: LoginBloc.instance.usernameStream,
                                    builder: (context, snapshot) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: CustomTextField(
                                          withLabel: true,
                                          focusNode: usernameNode,
                                          alignLabel: focusOnUsername,
                                          onTap: () {
                                            setState(
                                                () => focusOnUsername = false);
                                          },
                                          onChange:
                                              LoginBloc.instance.updateUsername,
                                          hint:
                                              allTranslations.text("username"),
                                          type: TextInputType.emailAddress,
                                          validate: (v) {
                                            if (NameValidator.nameValidator(
                                                    v) !=
                                                null) {
                                              LoginBloc.instance.username
                                                  .addError(NameValidator
                                                      .nameValidator(v)!);
                                            }
                                          },
                                          customError: snapshot.hasError,
                                          errorText: snapshot.error,
                                        ),
                                      );
                                    }),
                                StreamBuilder<String?>(
                                    stream: LoginBloc.instance.passwordStream,
                                    builder: (context, snapshot) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: CustomTextField(
                                          withLabel: true,
                                          focusNode: passwordNode,
                                          alignLabel: focusOnPassword,
                                          onTap: () {
                                            setState(
                                                () => focusOnUsername = false);
                                          },
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: InkWell(
                                              onTap: () => setState(() =>
                                                  showPassword = !showPassword),
                                              child: customImageIconSVG(
                                                imageName: showPassword
                                                    ? 'show'
                                                    : 'hide',
                                              ),
                                            ),
                                          ),
                                          hint:
                                              allTranslations.text("password"),
                                          onChange:
                                              LoginBloc.instance.updatePassword,
                                          obscureText: !showPassword,
                                          maxLines: 1,
                                          validate: (v) {
                                            if (PasswordValidator
                                                    .passwordValidator(v) !=
                                                null) {
                                              LoginBloc.instance.password
                                                  .addError(PasswordValidator
                                                      .passwordValidator(v)!);
                                            }
                                          },
                                          customError: snapshot.hasError,
                                          errorText: snapshot.error,
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            BlocBuilder<LoginBloc, AppState>(
                              builder: (context, state) {
                                return StreamBuilder<bool>(
                                    stream: LoginBloc.instance.submitStream,
                                    builder: (context, snapshot) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 32),
                                        child: CustomBtn(
                                          btnHeight: 58,
                                          radius: 10,
                                          color: Styles.PRIMARY_COLOR,
                                          btnWidth: MediaQueryHelper.width,
                                          text: allTranslations.text("login"),
                                          onTap: () {
                                            print(
                                                "${_globalKey.currentState!.validate()}  ${snapshot.data}");
                                            if (snapshot.hasData) {
                                              if (snapshot.data!)
                                                LoginBloc.instance.add(Click());
                                            } else {
                                              return;
                                            }
                                          },
                                          loading:
                                              state is Loading ? true : false,
                                          txtColor: Colors.white,
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
