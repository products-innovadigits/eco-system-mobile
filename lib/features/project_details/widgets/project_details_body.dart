import 'package:eco_system/features/project_details/widgets/project_details_description.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/shimmer/custom_shimmer.dart';
import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import '../../../helpers/translation/all_translation.dart';
import '../../../widgets/custom_expansion_card.dart';
import '../../projects/widgets/project_card_content.dart';
import '../bloc/project_details_bloc.dart';
import '../model/project_details_model.dart';

class ProjectDetailsBody extends StatelessWidget {
  const ProjectDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          ProjectDetailsModel model = state.model as ProjectDetailsModel;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ProjectCardContent(project: model),
              ),
              SizedBox(height: 12.h),
              Divider(color: Styles.BORDER_COLOR, thickness: 1.0),

              ///Objective Description
              CustomExpansionCard(
                title: allTranslations.text("description"),
                child: ProjectDetailsDescription(
                  description: model.description,
                  startDate: model.startDate,
                  endDate: model.endDate,
                ),
              ),
            ],
          );
        }
        if (state is Loading) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomShimmerContainer(
                  height: 130.h,
                  width: context.w,
                ),
              ),
              SizedBox(height: 12.h),
              Divider(color: Styles.BORDER_COLOR, thickness: 1.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: CustomShimmerContainer(
                  height: 130.h,
                  width: context.w,
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
