import 'package:eco_system/features/ats/talent_pool/view/sections/talent_pool_list_section.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/multiple_select_btn_widget.dart';
import 'package:eco_system/utility/export.dart';

class TalentPoolView extends StatelessWidget {
  const TalentPoolView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TalentPoolBloc()..add(Click()),
      child: BlocBuilder<TalentPoolBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<TalentPoolBloc>();
          final filtrationBloc = context.read<FiltrationBloc>();
          return Scaffold(
            appBar: CustomAppBar(
                title: allTranslations.text(LocaleKeys.talent_pool),
                withSearch: true,
                withFilter: true,
                withSorting: true,
                onTapSearch: () => CustomNavigator.push(Routes.SEARCH),
                action: MultipleSelectBtnWidget(),
                searchHintText:
                    allTranslations.text(LocaleKeys.searching_for_candidate),
                onFiltering: () => PopUpHelper.showBottomSheet(
                      child: BlocProvider.value(
                        value: filtrationBloc..reset(),
                        child: const CandidatesFilterBottomSheet(
                            isTalentPool: true),
                      ),
                    ),
                onSorting: () => PopUpHelper.showBottomSheet(
                      child: BlocProvider.value(
                        value: bloc..selectedSorting = null,
                        child: const SortingBottomSheet(),
                      ),
                    )),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: state is Loading
                  ? LoadingShimmerList()
                  : state is Done
                      ? const TalentPoolListSection()
                      : state is Empty || state is Error
                          ? EmptyContainer(
                              txt: allTranslations.text("oops"),
                              subText: allTranslations.text(state is Error
                                  ? LocaleKeys.something_went_wrong
                                  : LocaleKeys.there_is_no_data),
                            )
                          : const SizedBox(),
            ),
            bottomNavigationBar: BlocBuilder<TalentPoolBloc, AppState>(
              builder: (context, state) {
                return bloc.selectedTalentsList.isNotEmpty
                    ? const TalentPoolBottomNav()
                    : const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
