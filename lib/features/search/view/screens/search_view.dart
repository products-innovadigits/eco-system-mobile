import 'package:eco_system/features/search/bloc/search_bloc.dart';
import 'package:eco_system/features/search/view/sections/empty_search_section.dart';
import 'package:eco_system/features/search/view/sections/search_history_section.dart';
import 'package:eco_system/utility/export.dart';

import '../sections/jobs_search_section.dart';
import '../sections/talent_pool_search_section.dart';

class SearchView extends StatelessWidget {
  final SearchEnum searchEnum;

  const SearchView({super.key, required this.searchEnum});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: BlocBuilder<SearchBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<SearchBloc>();
          return Scaffold(
            appBar: CustomAppBar(
                title: allTranslations.text(LocaleKeys.candidates),
                withSearch: true,
                withCancelBtn: bloc.searchController.text.isNotEmpty,
                onCanceling: () => bloc.add(CancelSearch()),
                searchController: bloc.searchController,
                onSearching: (v) => bloc.add(Searching(arguments: searchEnum)),
                onTapSearch: () => bloc.add(TapSearch()),
                searchHintText:
                    allTranslations.text(LocaleKeys.searching_for_candidate)),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: bloc.searchController.text.isNotEmpty
                  ? _getSearchList(searchEnum)
                  : bloc.isActiveSearching
                      ? SearchHistorySection()
                      : EmptySearchSection(),
            ),
          );
        },
      ),
    );
  }
}

Widget _getSearchList(SearchEnum searchEnum) {
  switch (searchEnum) {
    case SearchEnum.talentPool:
      return const TalentPoolSearchSection();
    case SearchEnum.jobs:
      return const JobsSearchSection();
    default:
      return const TalentPoolSearchSection();
  }
}
