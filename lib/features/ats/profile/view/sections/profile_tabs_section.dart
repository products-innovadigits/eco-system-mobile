import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/enums.dart';
import 'package:eco_system/features/ats/profile/view/widgets/profile_tab_widget.dart';
import 'package:flutter/material.dart';

class ProfileTabsSection extends StatefulWidget {
  final Function(ProfileEnum) onTabSelected;

  const ProfileTabsSection({super.key, required this.onTabSelected});

  @override
  State<ProfileTabsSection> createState() => _ProfileTabsSectionState();
}

class _ProfileTabsSectionState extends State<ProfileTabsSection> {
  ProfileEnum selectedTab = ProfileEnum.profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileTabWidget(
            title: LocaleKeys.profile,
            isSelected: selectedTab == ProfileEnum.profile,
            onTap: () {
              setState(() {
                selectedTab = ProfileEnum.profile;
              });
              widget.onTabSelected(ProfileEnum.profile);
            }),
        ProfileTabWidget(
            title: LocaleKeys.events,
            isSelected: selectedTab == ProfileEnum.events,
            onTap: () {
              setState(() {
                selectedTab = ProfileEnum.events;
              });
              widget.onTabSelected(ProfileEnum.events);
            }),
        ProfileTabWidget(
            title: LocaleKeys.answers,
            isSelected: selectedTab == ProfileEnum.answers,
            onTap: () {
              setState(() {
                selectedTab = ProfileEnum.answers;
              });
              widget.onTabSelected(ProfileEnum.answers);
            }),
      ],
    );
  }
}
