import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/search/bloc/search_bloc.dart';
import 'package:eco_system/features/search/view/sections/empty_search_section.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_app_bar.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(),
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
                onSearching: (v) => bloc.add(Searching(arguments: v)),
                onTapSearch: () => bloc.add(TapSearch()),
                searchHintText:
                    allTranslations.text(LocaleKeys.searching_for_candidate)),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: bloc.isActiveSearching
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              allTranslations.text(LocaleKeys.search_history),
                              style: AppTextStyles.w400
                                  .copyWith(color: Styles.SUB_TEXT_DARK_COLOR),
                            ),
                            Text(allTranslations.text(LocaleKeys.delete),
                                style: AppTextStyles.w400.copyWith(
                                    color: Styles.PRIMARY_COLOR, fontSize: 12)),
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
                                      style: AppTextStyles.w400
                                          .copyWith(color: Styles.TEXT_COLOR),
                                    ),
                                    const Spacer(),
                                    Images(image: Assets.svgs.arrowHistory.path)
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
