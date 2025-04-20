import 'package:eco_system/features/objective_details/bloc/objective_kpis_bloc.dart';
import 'package:eco_system/features/objective_details/model/objective_indicator_model.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/shimmer/custom_shimmer.dart';
import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import 'objective_details_layout.dart';

class ObjectiveKPIS extends StatelessWidget {
  const ObjectiveKPIS({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveKPISBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          List<ObjectiveKPIModel> list = state.list as List<ObjectiveKPIModel>;
          return ObjectiveDetailsLayout(
            title: allTranslations.text("kpis"),
            subTitle: "${list.length} ${allTranslations.text("scale")}",
            child: Column(
              children: List.generate(
                  list.length,
                  (i) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                list[i].kpiTitle ?? "",
                                style: AppTextStyles.w400.copyWith(
                                  fontSize: 12,
                                  color: Styles.TITLE,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: LinearProgressIndicator(
                                    value: (list[i].value ?? 0) / 100,
                                    color: Styles.PRIMARY_COLOR,
                                    backgroundColor: Styles.HINT,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${list[i].value ?? ""}%",
                              style: AppTextStyles.w700
                                  .copyWith(fontSize: 12, color: Styles.HEADER),
                            ),
                          ],
                        ),
                      )),
            ),
          );
        }
        if (state is Loading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: CustomShimmerContainer(
              height: 130.h,
              width: context.w,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
