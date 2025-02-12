import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/shimmer/custom_shimmer.dart';
import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import '../../../helpers/translation/all_translation.dart';
import '../../objectives/widgets/objective_card_content.dart';
import '../bloc/objective_details_bloc.dart';
import '../model/objective_details_model.dart';
import 'objective_description.dart';
import 'objective_details_layout.dart';

class ObjectiveDetailsBody extends StatelessWidget {
  const ObjectiveDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ObjectiveDetailsBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          ObjectiveDetailsModel model =
          state.model as ObjectiveDetailsModel;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ObjectiveCardContent(objective: model),
              ),
              SizedBox(height: 12.h),
              Divider(color: Styles.BORDER_COLOR, thickness: 1.0),

              ///Objective Description
              ObjectiveDetailsLayout(
                title: allTranslations.text("description"),
                child: ObjectiveDetailsDescription(
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
              CustomShimmerContainer(
                height: 130.h,
                width: context.w,
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
