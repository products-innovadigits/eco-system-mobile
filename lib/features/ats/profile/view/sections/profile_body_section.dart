import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_tabs_section.dart';
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
          ],
        ));
      },
    );
  }
}
