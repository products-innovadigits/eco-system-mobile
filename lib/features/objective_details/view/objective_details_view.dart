import 'package:eco_system/components/empty_container.dart';
import 'package:eco_system/features/objective_details/bloc/objective_details_bloc.dart';
import 'package:eco_system/features/objective_details/model/objective_details_model.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/animated_widget.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import '../../objectives/widgets/objective_card_content.dart';
import '../widgets/objective_details_description.dart';
import '../widgets/objective_details_layout.dart';

class ObjectiveDetailsView extends StatelessWidget {
  const ObjectiveDetailsView({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "",
        withBottomBorder: false,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              ObjectiveDetailsBloc()..add(Click(arguments: id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<ObjectiveDetailsBloc, AppState>(
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
                          ListAnimator(
                            customPadding:
                                EdgeInsets.symmetric(horizontal: 16.w),
                            data: [
                              ///Objective Details Description
                              ObjectiveDetailsLayout(
                                title: allTranslations.text("description"),
                                child: ObjectiveDetailsDescription(
                                  description: model.description,
                                  startDate: model.startDate,
                                  endDate: model.endDate,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    if (state is Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is Error || state is Empty) {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<ObjectiveDetailsBloc>()
                              .add(Click(arguments: id));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                customPadding:
                                    EdgeInsets.symmetric(horizontal: 16.w),
                                data: [
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  EmptyContainer(
                                    txt:
                                        allTranslations.text("no_result_found"),
                                    subText: state is Error
                                        ? allTranslations
                                            .text("something_went_wrong")
                                        : allTranslations.text(
                                            "no_result_found_description"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
