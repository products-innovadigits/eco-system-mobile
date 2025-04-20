import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/bloc/candidates_bloc.dart';
import 'package:eco_system/features/ats/view/sections/candidate/all_candidates_section.dart';
import 'package:eco_system/features/ats/view/sections/candidate/candidates_filter_bottom_sheet.dart';
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
    return BlocProvider(
      create: (_) =>
      CandidatesBloc()
        ..add(InitCandidates(arguments: selectedStage)),
      child: BlocBuilder<CandidatesBloc, AppState>(
        builder: (context, state) {
          final bloc = context.read<CandidatesBloc>();
          return Scaffold(
            appBar: CustomAppBar(
                title: allTranslations.text(LocaleKeys.candidates),
                withSearch: true,
                withFilter: true,
                readOnly: true,
                onFiltering: () {
                  PopUpHelper.showBottomSheet(
                      context: context,
                      child: BlocProvider.value(
                        value: bloc..reset(),
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
      ),
    );
  }
}
