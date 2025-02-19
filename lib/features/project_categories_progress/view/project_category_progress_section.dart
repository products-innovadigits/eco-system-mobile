import 'package:eco_system/components/shimmer/custom_shimmer.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_event.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/section_title.dart';
import '../bloc/project_categories_progress_bloc.dart';
import '../model/project_category_progress_model.dart';
import '../widgets/project_category_h_bar_chart.dart';

class ProjectCategoryProgressSection extends StatelessWidget {
  const ProjectCategoryProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProjectCategoriesProgressBloc()..add(Click()),
        ),
      ],
      child: BlocBuilder<ProjectCategoriesProgressBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            List<ProjectCategoryProgressModel> projectCategoriesProgress =
                state.list as List<ProjectCategoryProgressModel>;
            return Container(
              width: context.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
              child: Column(
                children: [
                  SectionTitle(
                    title: allTranslations
                        .text("project_progress_rate_in_each_category"),
                    withView: false,
                    // onViewTap: () => CustomNavigator.push(Routes.PROJECTS),
                  ),
                  Divider(color: Styles.BORDER_COLOR),
                  ProjectCategoryHBarChart(data: projectCategoriesProgress),
                ],
              ),
            );
          }
          if (state is Loading) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CustomShimmerContainer(
                height: context.h * 0.2,
                width: context.w,
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
