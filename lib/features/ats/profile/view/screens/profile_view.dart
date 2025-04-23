import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_body_section.dart';
import 'package:eco_system/features/ats/profile/view/sections/profile_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        body: Column(
          children: [
            ProfileHeaderSection(),
            ProfileBodySection(),
          ],
        ),
      ),
    );
  }
}
