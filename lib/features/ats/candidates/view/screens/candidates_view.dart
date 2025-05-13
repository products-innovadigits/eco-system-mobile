import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/bloc/filtration_bloc.dart';
import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/features/ats/candidates/view/sections/all_candidates_section.dart';
import 'package:eco_system/features/ats/candidates/view/sections/candidates_filter_bottom_sheet.dart';
import 'package:eco_system/helpers/popup_helper.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Candidates extends StatelessWidget {
  final String selectedStage;

  const Candidates({super.key, required this.selectedStage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<CandidatesBloc>();
        final filtrationBloc = context.read<FiltrationBloc>();
        return Scaffold(
          appBar: CustomAppBar(
              title: allTranslations.text(LocaleKeys.candidates),
              withSearch: true,
              withFilter: true,
              readOnly: true,
              onFiltering: () {
                PopUpHelper.showBottomSheet(
                    child: BlocProvider.value(
                      value: filtrationBloc..reset(),
                      child: CandidatesFilterBottomSheet(),
                    ));
              },
              onTapSearch: () => CustomNavigator.push(Routes.SEARCH),
              searchHintText:
              allTranslations.text(LocaleKeys.searching_for_candidate)),
          body: SingleChildScrollView(
            controller: bloc.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: AllCandidatesSection(),
          ),
        );
      },
    );
  }
}
