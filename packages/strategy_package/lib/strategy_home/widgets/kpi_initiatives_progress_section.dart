

import 'package:strategy_package/strategy_home/model/kpis_initiatives_progress_model.dart';

import '../../shared/strategy_exports.dart';

class KpiInitiativesProgressSection extends StatelessWidget {
  const KpiInitiativesProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StrategyBloc, AppState>(
      builder: (context, state) {
        return Container(
          width: context.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.color.outline),
          ),
          child: Column(
            children: [
              SectionTitle(
                title: allTranslations.text(
                    LocaleKeys.kpis_initiatives_objective
                ),
              ),
              Divider(color: context.color.outline),
              SizedBox(height: 12.h),
              KpisInitiativesProgressChart(
                data: [
                  KpisInitiativesProgressModel(
                    objective: 'مركز اتصال وخدمة',
                    kpisValue: 60,
                    initiativesValue: 30,
                  ),
                  KpisInitiativesProgressModel(
                    objective: 'تطوير المنتجات',
                    kpisValue: 30,
                    initiativesValue: 35,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                runSpacing: 8.w,
                spacing: 24.h,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.color.primary,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          allTranslations.text("kpis"),
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.color.tertiary,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          allTranslations.text(LocaleKeys.initiatives),
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
        // if (state is Done) {
        //   List<KpisInitiativesProgressModel> list =
        //   state.list as List<KpisInitiativesProgressModel>;
        //   return Column(
        //     children: [
        //       // ObjectiveLineChart(data: list),
        //       KpisInitiativesProgressChart(data: list),
        //       // ObjectiveBarChartSyncfusion(data: [
        //       //   ObjectiveChartModel(
        //       //     objectValue: 60,
        //       //     kpisValue: 30,
        //       //     initiativesValue: 30,
        //       //     year: 2025
        //       //   ),
        //       // ]),
        //       Wrap(
        //         alignment: WrapAlignment.start,
        //         direction: Axis.horizontal,
        //         runSpacing: 8.w,
        //         spacing: 24.h,
        //         children: [
        //           Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Icon(
        //                 Icons.circle,
        //                 color: context.color.secondary,
        //                 size: 14,
        //               ),
        //               SizedBox(width: 4.w),
        //               Flexible(
        //                 child: Text(
        //                   allTranslations.text(LocaleKeys.objectives),
        //                   style: context.textTheme.bodySmall,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Icon(
        //                 Icons.circle,
        //                 color: context.color.primary,
        //                 size: 14,
        //               ),
        //               SizedBox(width: 4.w),
        //               Flexible(
        //                 child: Text(
        //                   allTranslations.text(LocaleKeys.initiatives),
        //                   style: context.textTheme.bodySmall,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Icon(
        //                 Icons.circle,
        //                 color: context.color.tertiary,
        //                 size: 14,
        //               ),
        //               SizedBox(width: 4.w),
        //               Flexible(
        //                 child: Text(
        //                   allTranslations.text("kpis"),
        //                   style: context.textTheme.bodySmall,
        //                 ),
        //               ),
        //             ],
        //           ),
        //
        //
        //         ],
        //       ),
        //     ],
        //   );
        // }
        // if (state is Loading) {
        //   return Padding(
        //     padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        //     child: CustomShimmerContainer(height: 200.h, width: context.w),
        //   );
        // } else {
        //   return const SizedBox();
        // }
      },
    );
  }
}
