import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/enums.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/widgets/custom_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingTabsSection extends StatefulWidget {
  const RatingTabsSection({super.key});

  @override
  State<RatingTabsSection> createState() => _RatingTabsSectionState();
}

class _RatingTabsSectionState extends State<RatingTabsSection> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CustomTabWidget(
        title: LocaleKeys.add_rating,
        isSelected: selectedTabIndex == 0,
        onTap: () {
          context.read<ProfileBloc>().selectedRatingTabIndex = 0;
          setState(() {
            selectedTabIndex = 0;
          });
        },
      ),
      CustomTabWidget(
        title: LocaleKeys.ratings,
        isSelected: selectedTabIndex == 1,
        onTap: () {
          context.read<ProfileBloc>().selectedRatingTabIndex = 1;
          setState(() {
            selectedTabIndex = 1;
          });
        },
      )
    ]);
  }
}
