import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/enums.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/widgets/custom_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTabsSection extends StatelessWidget {
  const ProfileTabsSection({super.key});

  static Map<ProfileEnum, String> tabTitles = {
    ProfileEnum.profile: LocaleKeys.profile,
    ProfileEnum.events: LocaleKeys.events,
    ProfileEnum.answers: LocaleKeys.answers,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ProfileEnum.values.map((tab) {
        return CustomTabWidget(
          title: tabTitles[tab] ?? '',
          isSelected: context.watch<ProfileBloc>().selectedTab == tab,
          onTap: () {
            context.read<ProfileBloc>().add(Select(arguments: tab));
          },
        );
      }).toList(),
    );
  }
}
