import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/profile/view/widgets/profile_tab_widget.dart';
import 'package:flutter/material.dart';

class ProfileTabsSection extends StatefulWidget {
  final Function(int) onTabSelected;

  const ProfileTabsSection({super.key, required this.onTabSelected});

  @override
  State<ProfileTabsSection> createState() => _ProfileTabsSectionState();
}

class _ProfileTabsSectionState extends State<ProfileTabsSection> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileTabWidget(
            title: LocaleKeys.profile,
            isSelected: selectedIndex == 0,
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
              widget.onTabSelected(0);
            }),
        ProfileTabWidget(
            title: LocaleKeys.events,
            isSelected: selectedIndex == 1,
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
              widget.onTabSelected(1);
            }),
        ProfileTabWidget(
            title: LocaleKeys.answers,
            isSelected: selectedIndex == 2,
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
              widget.onTabSelected(2);
            }),
      ],
    );
  }
}
