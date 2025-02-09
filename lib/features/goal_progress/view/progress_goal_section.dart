import 'package:eco_system/components/shimmer/custom_shimmer.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/goal_progress/bloc/goal_progress_bloc.dart';
import 'package:eco_system/features/goal_progress/model/goal_progress_model.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extintions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_event.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/section_title.dart';
import '../../goal_progress/widgets/goal_progress_chart.dart';

class ProgressGoalSection extends StatelessWidget {
  const ProgressGoalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalProgressBloc()..add(Click()),
      child: BlocBuilder<GoalProgressBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            GoalProgressModel model = state.model as GoalProgressModel;
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
                    title: allTranslations.text("goal_progress_rate"),
                    withView: true,
                  ),
                  GoalProgressChart(),
                  SizedBox(height: 12.h),
                  Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    runSpacing: 12.w,
                    spacing: 8.h,
                    children: List.generate(
                        3,
                        (i) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Styles.PRIMARY_COLOR,
                                  size: 12,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: allTranslations.text(i == 0
                                          ? "in_progress"
                                          : i == 1
                                              ? "done"
                                              : "pending"),
                                      style: AppTextStyles.w400.copyWith(
                                          fontSize: 12, color: Styles.HEADER),
                                      children: [
                                        TextSpan(
                                          text: " ${78}",
                                          style: AppTextStyles.w400.copyWith(
                                              fontSize: 12,
                                              color: Styles.DETAILS),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  )
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
