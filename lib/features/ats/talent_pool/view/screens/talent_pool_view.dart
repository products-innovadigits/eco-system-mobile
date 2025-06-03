import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/sorting_bottom_sheet.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/talent_pool_bottom_nav_bar.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/talent_pool_list_section.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/multiple_select_btn_widget.dart';
import 'package:eco_system/utility/export.dart';

import '../sections/talent_pool_filter_bottom_sheet.dart';

class TalentPoolView extends StatelessWidget {
  const TalentPoolView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TalentPoolBloc()..add(Click(arguments: SearchEngine())),
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
                            value: context.read<TalentPoolBloc>()
                              ..selectedSorting = null,
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
