import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if (context.read<JobsBloc>().searchController.text.isNotEmpty) {
            context.read<JobsBloc>().searchController.clear();
            context.read<JobsBloc>().add(Click(arguments: SearchEngine()));
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.jobs),
          withSearch: true,
          withCancelBtn: true,
          onCanceling: () => context.read<JobsBloc>().onCancelSearch(),
          // onTapSearch: () =>
          //     CustomNavigator.push(Routes.SEARCH, arguments: SearchEnum.jobs),
          searchHintText: allTranslations.text(LocaleKeys.searching_for_job),
          searchController: context.read<JobsBloc>().searchController,
          onSearching: (value) => context
              .read<JobsBloc>()
              .add(Click(arguments: SearchEngine(searchText: value))),
          onBackBtn: () {
            if (context.read<JobsBloc>().searchController.text.isNotEmpty) {
              context.read<JobsBloc>().searchController.clear();
              context.read<JobsBloc>().add(Click(arguments: SearchEngine()));
            }
          },
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: BlocBuilder<JobsBloc, AppState>(
              builder: (context, state) {
                return switch (state) {
                // ── Loading ─────────────────────────
                  Loading() => const ShimmerCardsList(),

                // ── Done ────────────────────────────
                  Done(:final loading) => Column(
                    children: [
                      const Expanded(child: JobsListSection()),
                      CustomLoading(isTextLoading: true, loading: loading),
                    ],
                  ),

                // ── Empty ───────────────────────────
                  Empty(:final initial) => EmptyContainer(
                    desc: initial == true
                        ? allTranslations.text(LocaleKeys.no_data_desc)
                        : allTranslations.text(LocaleKeys.there_is_no_data),
                  ),

                // ── Fallback (Error / unexpected) ───
                  _ => EmptyContainer(
                    img: Assets.svgs.error.path,
                    txt: allTranslations.text(LocaleKeys.page_not_found),
                    desc: allTranslations.text(LocaleKeys.page_not_found_desc),
                  ),
                };
              }
          ),
        ),
      ),
    );
  }
}
