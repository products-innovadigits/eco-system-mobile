import 'package:eco_system/features/objectives/widgets/objective_card.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/model/search_engine.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/animated_widget.dart';
import '../../../components/custom_loading.dart';
import '../../../components/empty_container.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../bloc/objectives_bloc.dart';
import '../model/objectives_model.dart';

class ObjectivesView extends StatelessWidget {
  const ObjectivesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: allTranslations.text("strategic_performance_system"),
      ),
      body: SafeArea(
          child: BlocProvider(
        create: (context) =>
            ObjectivesBloc()..add(Click(arguments: SearchEngine())),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Text(
                    allTranslations.text("all_objectives"),
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 16, color: Styles.HEADER),
                  ),
                ],
              ),
            ),
            Expanded(child: BlocBuilder<ObjectivesBloc, AppState>(
              builder: (context, state) {
                if (state is Loading) {
                  return ListAnimator(
                    customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    data: List.generate(
                        10,
                        (index) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: CustomShimmerContainer(
                                height: 125.h,
                                width: context.w,
                              ),
                            )),
                  );
                }
                if (state is Done) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListAnimator(
                          customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          controller:
                              context.read<ObjectivesBloc>().scrollController,
                          data: state.cards,
                        ),
                      ),
                      CustomLoading(isTextLoading: true, loading: state.loading)
                    ],
                  );
                }
                if (state is Empty || state is Error) {
                  return ListAnimator(
                    customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    data: [
                      EmptyContainer(
                        txt: allTranslations.text("oops"),
                        subText: allTranslations.text(state is Error
                            ? "something_went_wrong"
                            : "there_is_no_data"),
                      ),
                    ],
                  );
                } else {
                  return ListAnimator(
                    customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    data: List.generate(10,
                        (index) => ObjectiveCard(objective: ObjectiveModel())),
                  );
                }
              },
            ))
          ],
        ),
      )),
    );
  }
}
