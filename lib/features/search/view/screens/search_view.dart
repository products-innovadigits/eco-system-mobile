import 'package:eco_system/features/search/bloc/search_bloc.dart';
import 'package:eco_system/features/search/view/sections/empty_search_section.dart';
import 'package:eco_system/utility/export.dart';

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
                  ? TalentPoolSearchSection()
                  : bloc.isActiveSearching
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  allTranslations
                                      .text(LocaleKeys.search_history),
                                  style: AppTextStyles.w400.copyWith(
                                      color: Styles.SUB_TEXT_DARK_COLOR),
                                ),
                                Text(allTranslations.text(LocaleKeys.delete),
                                    style: AppTextStyles.w400.copyWith(
                                        color: Styles.PRIMARY_COLOR,
                                        fontSize: 12)),
                              ],
                            ),
                            12.sh,
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                separatorBuilder: (context, index) => 16.sh,
                                itemBuilder: (context, index) => Row(
                                      children: [
                                        Images(image: Assets.svgs.clock.path),
                                        8.sw,
                                        Text(
                                          'قائد تصميم المنتجات ',
                                          style: AppTextStyles.w400.copyWith(
                                              color: Styles.TEXT_COLOR),
                                        ),
                                        const Spacer(),
                                        Images(
                                            image:
                                                Assets.svgs.arrowHistory.path)
                                      ],
                                    )),
                          ],
                        )
                      : EmptySearchSection(),
            ),
          );
        },
      ),
    );
  }
}
