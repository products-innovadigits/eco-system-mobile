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
  final bool isCandidate;
  const ProfileBodySection({super.key, required this.isCandidate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final selectedTab =
            context.select((ProfileBloc bloc) => bloc.selectedTab);
        return Expanded(
          child: Column(
            children: [
              ProfileTabsSection(isCandidate: isCandidate),
              20.sh,
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _getTabSection(selectedTab , context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getTabSection(ProfileEnum selectedTab , BuildContext context) {
    switch (selectedTab) {
      case ProfileEnum.answers:
        return AnswersSection();
      case ProfileEnum.events:
        return EventsSection();
      case ProfileEnum.profile:
      default:
        return ProfileSection();
    }
  }
}
