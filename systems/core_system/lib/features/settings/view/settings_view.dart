import 'package:core_system/core/utility/export.dart';
import 'package:core_system/features/settings/bloc/settings_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(),
      child: const _SettingsScaffold(),
    );
  }
}

class _SettingsScaffold extends StatelessWidget {
  const _SettingsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: allTranslations.text(LocaleKeys.settings)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SettingsHeader(
          //   onEditPressed: () {
          //     // Wire to profile / edit screen when a shell route is available.
          //   },
          // ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      children: [
                        const _LanguageSettingsCard(),
                        SizedBox(height: 12.h),
                        // _SettingsCard(
                        //   onTap: () => context.read<SettingsBloc>().add(
                        //     Click(arguments: 'employees'),
                        //   ),
                        //   leading: Images(
                        //     image: Assets.svgs.multiUser.path,
                        //     width: 22.w,
                        //     height: 22.w,
                        //     color: context.color.primary,
                        //   ),
                        //   title: allTranslations.text(LocaleKeys.employees),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: BlocBuilder<SettingsBloc, AppState>(
                      builder: (context, state) {
                        final loading = state is Loading;
                        return CustomBtn(
                          text: allTranslations.text(LocaleKeys.logout),
                          color: context.color.error,
                          loading: loading,
                          onPressed: loading
                              ? null
                              : () => context.read<SettingsBloc>().add(
                                  Click(arguments: 'logout'),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSettingsCard extends StatelessWidget {
  const _LanguageSettingsCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: mainAppBloc.langStream,
      initialData: allTranslations.currentLanguage,
      builder: (context, snapshot) {
        final raw = snapshot.data ?? allTranslations.currentLanguage;
        final code = (raw == 'en' || raw == 'ar') ? raw : 'en';

        return Material(
          color: context.color.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.color.outline),
            ),
            child: Row(
              children: [
                Images(
                  image: Assets.svgs.languageCircle.path,
                  width: 22.w,
                  height: 22.w,
                  color: context.color.primary,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    allTranslations.text(LocaleKeys.change_lang),
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: code,
                    isDense: true,
                    borderRadius: BorderRadius.circular(12),
                    style: context.textTheme.bodyMedium,
                    dropdownColor: context.color.surfaceContainer,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'en',
                        child: Text(
                          allTranslations.text(LocaleKeys.language_english),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'ar',
                        child: Text(
                          allTranslations.text(LocaleKeys.language_arabic),
                        ),
                      ),
                    ],
                    onChanged: (v) async {
                      if (v == null || v == code) return;
                      await allTranslations.setNewLanguage(v, true);
                      final isLogin = await SharedHelper.sharedHelper!
                          .readBoolean(CachingKey.isLogin);
                      if (!isLogin) {
                        mainAppBloc.updateLang(v);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.leading, required this.title, this.onTap});

  final Widget leading;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.color.outline),
          ),
          child: Row(
            children: [
              leading,
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
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
