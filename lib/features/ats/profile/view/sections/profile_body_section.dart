import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/enums.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/answers_tab/answers_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/events_tab/events_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tab/profile_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tabs_section.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBodySection extends StatelessWidget {
  const ProfileBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<ProfileBloc>();
        return Expanded(
            child: Column(
          children: [
            ProfileTabsSection(
                onTabSelected: (index) => bloc.add(Select(arguments: index))),
            20.sh,
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: bloc.selectedTab == ProfileEnum.answers
                  ? AnswersSection()
                  : bloc.selectedTab == ProfileEnum.events
                      ? EventsSection()
                      : ProfileSection(),
            ))
          ],
        ));
      },
    );
  }
}
