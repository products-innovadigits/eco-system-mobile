import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/features/auth/login/bloc/login_bloc.dart';
import 'package:eco_system/features/auth/login/widgets/multi_select_systems_field.dart';
import 'package:eco_system/features/auth/login/widgets/welcome_widget.dart';

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
              final bloc = context.read<LoginBloc>();
              return Form(
                key: bloc.globalKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          data: [
                            const WelcomeWidget(),
                            SizedBox(height: 32.h),
                            StreamBuilder<LoginSystemPickMode>(
                              stream: bloc.systemPickMode.stream,
                              initialData: LoginSystemPickMode.allEnabled,
                              builder: (context, modeSnap) {
                                final mode = modeSnap.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        allTranslations.text(LocaleKeys.login_to),
                                        style: context.textTheme.labelSmall,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => bloc.setSystemPickMode(
                                              LoginSystemPickMode.allEnabled,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Radio<LoginSystemPickMode>(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    value: LoginSystemPickMode
                                                        .allEnabled,
                                                    groupValue: mode,
                                                    onChanged: (v) {
                                                      if (v != null) {
                                                        bloc.setSystemPickMode(
                                                          v,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      allTranslations.text(
                                                        LocaleKeys
                                                            .login_all_systems,
                                                      ),
                                                      style: context
                                                          .textTheme.bodyMedium,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => bloc.setSystemPickMode(
                                              LoginSystemPickMode.customize,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Radio<LoginSystemPickMode>(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    value: LoginSystemPickMode
                                                        .customize,
                                                    groupValue: mode,
                                                    onChanged: (v) {
                                                      if (v != null) {
                                                        bloc.setSystemPickMode(
                                                          v,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      allTranslations.text(
                                                        LocaleKeys
                                                            .login_customize_systems,
                                                      ),
                                                      style: context
                                                          .textTheme.bodyMedium,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (mode == LoginSystemPickMode.customize) ...[
                                      SizedBox(height: 12.h),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 6.0),
                                        child: Text(
                                          allTranslations.text(
                                            LocaleKeys.login_pick_systems,
                                          ),
                                          style: context.textTheme.labelSmall,
                                        ),
                                      ),
                                      StreamBuilder<Set<String>>(
                                        stream: bloc.customizedModuleIds.stream,
                                        initialData: const {},
                                        builder: (context, setSnap) {
                                          final ids = setSnap.data ?? {};
                                          return MultiSelectSystemsField(
                                            selectedModuleIds: ids,
                                            onChanged: bloc.setCustomizedModuleIds,
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            CustomTextField(
                              hint: allTranslations.text("enter_email"),
                              label: allTranslations.text("email"),
                              type: TextInputType.emailAddress,
                              validation: NotEmptyValidator.notEmptyValidator,
                              controller: bloc.mailTEC,
                            ),
                            SizedBox(height: 16.h),
                            CustomTextField(
                              hint: allTranslations.text("enter_password"),
                              label: allTranslations.text("password"),
                              type: TextInputType.visiblePassword,
                              validation: PasswordValidator.passwordValidator,
                              isPassword: true,
                              controller: bloc.passwordTEC,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 8.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
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
                          if (bloc.globalKey.currentState!.validate()) {
                            bloc.add(Click());
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
