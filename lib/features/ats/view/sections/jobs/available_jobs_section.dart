import 'package:eco_system/components/shimmer/custom_shimmer.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/ats/view/sections/jobs/jobs_list_section.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_event.dart';
import '../../../../../helpers/styles.dart';
import '../../../../../widgets/section_title.dart';
import '../../../bloc/jobs_bloc.dart';

class AvailableJobsSection extends StatelessWidget {
  const AvailableJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobsBloc()..add(Click()),
      child: BlocBuilder<JobsBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            JobsBloc jobsBloc = context.read<JobsBloc>();
            // List<JobsModel> objectives = state.list as List<JobsModel>;
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
                    title: allTranslations.text("available_jobs"),
                    withView: true,
                    onViewTap: (){
                      CustomNavigator.push(Routes.JOBS);
                    },
                  ),
                  Divider(color: Styles.BORDER_COLOR),
                  SizedBox(height: 12.h),
                  JobsListSection(),
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
