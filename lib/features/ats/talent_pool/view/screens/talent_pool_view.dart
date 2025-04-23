import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/features/ats/talent_pool/view/sections/talent_pool_bottom_nav_bar.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/talent_card_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TalentPoolView extends StatelessWidget {
  const TalentPoolView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TalentPoolBloc(),
      child: BlocBuilder<TalentPoolBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<TalentPoolBloc>();
          return Scaffold(
            appBar: CustomAppBar(
                title: allTranslations.text(LocaleKeys.talent_pool),
                withSearch: true,
                withFilter: true,
                withSorting: true,
                onSearching: (v) {},
                onFiltering: () {},
                onSorting: () {},
                action: bloc.activeSelection
                    ? Row(
                        children: [
                          Text(
                            allTranslations.text(LocaleKeys.select_all),
                            style: AppTextStyles.w400.copyWith(
                                fontSize: 12, color: Styles.PRIMARY_COLOR),
                          ),
                          8.sw,
                          GestureDetector(
                            onTap: () => bloc.add(Select(arguments: false)),
                            child: Text(
                              allTranslations.text(LocaleKeys.cancel),
                              style: AppTextStyles.w400.copyWith(
                                  fontSize: 10,
                                  color: Styles.SUB_TEXT_DARK_COLOR),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () => bloc.add(Select(arguments: true)),
                        child: Text(
                          allTranslations.text(LocaleKeys.select),
                          style: AppTextStyles.w400.copyWith(
                              fontSize: 12, color: Styles.PRIMARY_COLOR),
                        )),
                searchHintText:
                    allTranslations.text(LocaleKeys.searching_for_candidate)),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return TalentCardWidget(
                      onSelectTalent: (val) =>
                          bloc.add(SelectTalent(arguments: index)),
                      isSelectionActive: bloc.activeSelection);
                },
                separatorBuilder: (context, index) => 16.sh,
              ),
            ),
            bottomNavigationBar: BlocBuilder<TalentPoolBloc, AppState>(
              builder: (context, state) {
                return bloc.selectedTalentsList.isNotEmpty
                    ? TalentPoolBottomNav()
                    : const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
