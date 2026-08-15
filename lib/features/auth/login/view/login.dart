import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/features/auth/login/bloc/login_bloc.dart';
import 'package:eco_system/features/auth/login/widgets/welcome_widget.dart';

// Needed by the commented-out system picker below.
// import '../../../../app/modules/modules_registry.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        leadingWidth: 110.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Styles.logo(color: context.color.primary),
        ),
      ),
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

                            /// Login-time system picker, hidden on the demo
                            /// instance: the enabled systems share one backend,
                            /// so a single sign-in covers all of them and the
                            /// switcher in [MainHeader] moves between them
                            /// afterwards. Restore this together with
                            /// `LoginBloc.setSelectedSystem` if systems ever
                            /// need separate credentials again.
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.only(bottom: 6.0),
                            //       child: Text(
                            //         allTranslations.text("login_to"),
                            //         style: context.textTheme.labelSmall,
                            //       ),
                            //     ),
                            //     CustomDropList(
                            //       list: ModulesRegistry.enabledModules.indexed
                            //           .map(
                            //             (entry) => DropListModel(
                            //               id: entry.$1 + 1,
                            //               name: entry.$2.name,
                            //               key: entry.$2.id,
                            //             ),
                            //           )
                            //           .toList(),
                            //       hint: allTranslations.text("select_system"),
                            //       onChanged: (value) {
                            //         if (value.key != null) {
                            //           context
                            //               .read<LoginBloc>()
                            //               .setSelectedSystem(value.key!);
                            //         }
                            //       },
                            //       bgColor: LightColor.white,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 16.h),
                            CustomTextField(
                              // hint: allTranslations.text("enter_username"),
                              hint: allTranslations.text("enter_email"),
                              // label: allTranslations.text("username"),
                              label: allTranslations.text("email"),
                              type: TextInputType.emailAddress,
                              validation: NotEmptyValidator.notEmptyValidator,
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
                                vertical: 8.h,
                                horizontal: 8.w,
                              ),
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
                                      style: AppTextStyles.w400.copyWith(
                                        color: context.color.onSurface,
                                        fontSize: FontSizes.f14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
