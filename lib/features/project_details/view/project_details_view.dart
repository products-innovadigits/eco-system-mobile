import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/animated_widget.dart';
import '../../../core/app_event.dart';
import '../../../widgets/custom_app_bar.dart';
import '../bloc/project_details_bloc.dart';
import '../widgets/project_details_body.dart';

class ProjectDetailsView extends StatelessWidget {
  const ProjectDetailsView({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "", withBottomBorder: false),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ProjectDetailsBloc()..add(Click(arguments: id)),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Expanded(
                  child: ListAnimator(
                data: [
                  ///Objective Details
                  ProjectDetailsBody(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
