import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_body_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  final bool isCandidate;

  const ProfileView({super.key, this.isCandidate = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        body: Column(
          children: [
            ProfileHeaderSection(isCandidate: isCandidate),
            ProfileBodySection(isCandidate: isCandidate),
          ],
        ),
      ),
    );
  }
}
