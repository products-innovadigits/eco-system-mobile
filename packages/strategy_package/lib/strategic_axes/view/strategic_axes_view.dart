import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/widgets/strategic_axes_section.dart';
import 'package:strategy_package/bsc/widgets/vision_section.dart';
import 'package:strategy_package/strategic_axes/bloc/strategic_axes_bloc.dart';
import 'package:strategy_package/strategic_axes/widgets/strategic_axis_objectives_section.dart';

class StrategicAxesView extends StatelessWidget {
  const StrategicAxesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StrategicAxesBloc()..add(Click()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.strategic_axis),
        ),
        body: BlocBuilder<StrategicAxesBloc, AppState>(
          // buildWhen: (previous, current) => previous is! Done,
          builder: (context, state) {
            final bloc = context.read<StrategicAxesBloc>();
            if (state is Loading || state is Start) {
              return ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                data: List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomShimmerContainer(
                      height: 100.h,
                      width: context.w,
                    ),
                  ),
                ),
              );
            }
            if (state is Done) {
              final VisionDataModel visionData = state.data as VisionDataModel;
              return ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                data: [
                  /// Vision, Mission, Values
                  VisionSection(
                    visionTitle: visionData.title ?? '',
                    values: visionData.values ?? [],
                    messages: visionData.missions ?? [],
                  ),
                  24.sh,

                  /// Strategic Axes Section
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.surfaceContainer,
                      border: Border.all(
                        color: context.color.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        StrategicAxesSection(
                          axes: visionData.strategicAxises ?? [],
                          selectedAxes: bloc.selectedAxes,
                          isStrategicAxes: true,
                        ),
                        8.sh,

                        /// Objectives Section
                        StrategicAxisObjectivesSection(
                          objectivesList: [
                            ObjectActiveModel(
                              title: 'OBJ 1',
                              description: 'Description 1',
                              initiatives: [
                                IndicatorModel(
                                  title: 'Initiative 1',
                                  description: 'Description of Initiative 1',
                                ),
                              ],
                              kpIs: [
                                IndicatorModel(
                                  title: 'KPI 1',
                                  description: 'Description of KPI 1',
                                ),
                              ],
                              id: 1,
                            ),
                            ObjectActiveModel(
                              title: 'OBJ 2',
                              description: 'Description 2',
                              initiatives: [
                                IndicatorModel(
                                  title: 'Initiative 2',
                                  description: 'Description of Initiative 2',
                                ),
                              ],
                              kpIs: [
                                IndicatorModel(
                                  title: 'KPI 2',
                                  description: 'Description of KPI 2',
                                ),
                              ],
                              id: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return EmptyContainer(
                txt: allTranslations.text(LocaleKeys.something_went_wrong),
                img: Assets.svgs.error.path,
              );
            }
          },
        ),
      ),
    );
  }
}
