import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/enums.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/widgets/custom_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTabsSection extends StatelessWidget {
  final bool isCandidate;

  const ProfileTabsSection({super.key, required this.isCandidate});

  static Map<ProfileEnum, String> applicantTabTitles = {
    ProfileEnum.profile: LocaleKeys.profile,
    ProfileEnum.events: LocaleKeys.events,
    ProfileEnum.answers: LocaleKeys.answers,
  };

  static Map<ProfileEnum, String> candidateTabTitles = {
    ProfileEnum.profile: LocaleKeys.profile,
    ProfileEnum.events: LocaleKeys.events,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: (isCandidate ? candidateTabTitles : applicantTabTitles)
          .keys
          .map((tab) {
        return CustomTabWidget(
          title: applicantTabTitles[tab] ?? '',
          isSelected: context.watch<ProfileBloc>().selectedTab == tab,
          onTap: () {
            context.read<ProfileBloc>().add(Select(arguments: tab));
          },
        );
      }).toList(),
    );
  }
}
