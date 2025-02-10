import 'package:eco_system/components/shimmer/custom_shimmer.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/navigation/routes.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_event.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/section_title.dart';
import '../bloc/objective_active_categorized_bloc.dart';
import '../bloc/objective_active_percentage_bloc.dart';
import '../model/objective_active_model.dart';
import '../widgets/objective_active_chart.dart';

class ObjectiveActiveSection extends StatelessWidget {
  const ObjectiveActiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ObjectiveActiveCategorizedBloc()..add(Click()),
        ),
        BlocProvider(
          create: (context) => ObjectActivePercentageBloc()..add(Click()),
        ),
      ],
      child: BlocBuilder<ObjectiveActiveCategorizedBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            List<ObjectiveActiveModel> objectives =
                state.list as List<ObjectiveActiveModel>;
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
                    title: allTranslations.text("objective_active_rate"),
                    withView: true,
                    onViewTap: () => CustomNavigator.push(Routes.OBJECTIVES),
                  ),
                  ObjectiveActiveChart(objectives: objectives),
                  SizedBox(height: 12.h),
                  Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    runSpacing: 8.w,
                    spacing: 24.h,
                    children: List.generate(
                        objectives.length,
                        (i) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Styles.objectivesColors[i],
                                  size: 16,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: objectives[i].categoryName,
                                      style: AppTextStyles.w400.copyWith(
                                          fontSize: 14, color: Styles.HEADER),
                                      children: [
                                        // TextSpan(
                                        //   text: " ${78}",
                                        //   style: AppTextStyles.w400.copyWith(
                                        //       fontSize: 12,
                                        //       color: Styles.DETAILS),
                                        // )
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
