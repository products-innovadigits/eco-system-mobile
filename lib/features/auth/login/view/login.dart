import 'package:eco_system/components/animated_widget.dart';
import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_event.dart';
import '../../../../core/vaildator.dart';
import '../../../../helpers/styles.dart';
import '../../../../helpers/text_styles.dart';
import '../bloc/login_bloc.dart';
import '../widgets/welcome_widget.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100.h,
          leadingWidth: 80.w,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Styles.logo(color: Styles.PRIMARY_COLOR),
          )),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocBuilder<LoginBloc, AppState>(
            builder: (context, state) {
              return Form(
                key: context.read<LoginBloc>().globalKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          data: [
                            const WelcomeWidget(),
                            SizedBox(height: 32.h),
                            CustomTextField(
                              // hint: allTranslations.text("enter_username"),
                              hint: allTranslations.text("enter_email"),
                              // label: allTranslations.text("username"),
                              label: allTranslations.text("email"),
                              type: TextInputType.emailAddress,
                              // validation: EmailValidator.emailValidator,
                              controller: context.read<LoginBloc>().mailTEC,
                            ),
                            SizedBox(height: 16.h),
                            CustomTextField(
                              hint: allTranslations.text("enter_password"),
                              label: allTranslations.text("password"),
                              type: TextInputType.visiblePassword,
                              validation: PasswordValidator.passwordValidator,
                              isPassword: true,
                              controller: context.read<LoginBloc>().passwordTEC,
                            ),

                            ///Forget Password && Remember me
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 8.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // StreamBuilder<bool?>(
                                  //   stream: context
                                  //       .read<LoginBloc>()
                                  //       .rememberMeStream,
                                  //   builder: (_, snapshot) {
                                  //     return RememberMe(
                                  //       check: snapshot.data ?? false,
                                  //       onChange: (v) => context
                                  //           .read<LoginBloc>()
                                  //           .updateRememberMe(v),
                                  //     );
                                  //   },
                                  // ),
                                  const Expanded(child: SizedBox()),
                                  InkWell(
                                    onTap: () {
                                      context.read<LoginBloc>().clear();
                                    },
                                    child: Text(
                                      allTranslations.text("forget_password"),
                                      style: AppTextStyles.w700.copyWith(
                                        color: Styles.HEADER,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Styles.PRIMARY_COLOR,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomBtn(
                        text: allTranslations.text("login"),
                        loading: state is Loading,
                        onPressed: () {
                          if (context
                              .read<LoginBloc>()
                              .globalKey
                              .currentState!
                              .validate()) {
                            context.read<LoginBloc>().add(Click());
                          }
                        },
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
