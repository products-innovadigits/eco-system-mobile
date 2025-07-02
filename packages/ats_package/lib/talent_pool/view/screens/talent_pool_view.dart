import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class TalentPoolView extends StatelessWidget {
  const TalentPoolView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TalentPoolBloc()
        ..add(Click(arguments: SearchEngine())),
      child: BlocBuilder<TalentPoolBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<TalentPoolBloc>();
          return PopScope(
            canPop: !bloc.activeSelection,
            onPopInvoked: (didPop) {
              if (!didPop && bloc.activeSelection) {
                bloc.add(Select(arguments: false));
              }
            },
            child: Scaffold(
              appBar: CustomAppBar(
                  title: allTranslations.text(LocaleKeys.talent_pool),
                  withSearch: true,
                  withFilter: true,
                  isFiltered: bloc.isFiltered,
                  isSorted: bloc.appliedSorting != null,
                  withSorting: true,
                  withCancelBtn: true,
                  onSearching: (value) => bloc
                      .add(Click(arguments: SearchEngine(searchText: value))),
                  onCanceling: () => bloc.onCancelSearch(),
                  searchController: bloc.searchController,
                  action: MultipleSelectBtnWidget(),
                  searchHintText:
                      allTranslations.text(LocaleKeys.search_job_title_or_name),
                  onFiltering: () {
                    context.read<FiltrationBloc>().collapseExpandedLists();
                    PopUpHelper.showBottomSheet(
                      child: BlocProvider.value(
                          value: bloc, child: TalentPoolFilterBottomSheet()),
                    );
                  },
                  onSorting: () => PopUpHelper.showBottomSheet(
                        child: BlocProvider.value(
                            value: context.read<TalentPoolBloc>(),
                            child: const SortingBottomSheet()),
                      )),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: TalentPoolListSection(),
              ),
              bottomNavigationBar: bloc.selectedTalentsList.isNotEmpty
                  ? const TalentPoolBottomNav()
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
