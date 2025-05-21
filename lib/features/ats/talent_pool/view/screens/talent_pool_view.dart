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
          return Scaffold(
            appBar: CustomAppBar(
                title: allTranslations.text(LocaleKeys.talent_pool),
                withSearch: true,
                withFilter: true,
                isFiltered: bloc.isFiltered,
                withSorting: true,
                onTapSearch: () => CustomNavigator.push(Routes.SEARCH,
                    arguments: SearchEnum.talentPool),
                action: MultipleSelectBtnWidget(),
                searchHintText:
                    allTranslations.text(LocaleKeys.searching_for_candidate),
                onFiltering: () {
                  // context.read<FiltrationBloc>().reset();
                  PopUpHelper.showBottomSheet(
                    child: BlocProvider.value(
                      value: context.read<TalentPoolBloc>(),
                      child: const TalentPoolFilterBottomSheet(),
                    ),
                  );
                },
                onSorting: () => PopUpHelper.showBottomSheet(
                      child: BlocProvider.value(
                        value: context.read<TalentPoolBloc>()
                          ..selectedSorting = null,
                        child: const SortingBottomSheet(),
                      ),
                    )),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: TalentPoolListSection(),
            ),
            bottomNavigationBar: BlocBuilder<TalentPoolBloc, AppState>(
              builder: (context, state) {
                final bloc = context.read<TalentPoolBloc>();
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
