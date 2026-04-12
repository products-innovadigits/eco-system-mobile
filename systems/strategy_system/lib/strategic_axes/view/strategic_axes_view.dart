import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/bsc/widgets/strategic_axes_section.dart';
import 'package:strategy_system/bsc/widgets/vision_section.dart';
import 'package:strategy_system/strategic_axes/bloc/strategic_axes_bloc.dart';
import 'package:strategy_system/strategic_axes/strategic_axes_objectives_resolver.dart';
import 'package:strategy_system/strategic_axes/widgets/strategic_axis_objectives_section.dart';

class StrategicAxesView extends StatefulWidget {
  const StrategicAxesView({super.key});

  @override
  State<StrategicAxesView> createState() => _StrategicAxesViewState();
}

class _StrategicAxesViewState extends State<StrategicAxesView> {
  int _selectedAxisIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StrategicAxesBloc()..add(Click()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.strategic_axis),
        ),
        body: BlocBuilder<StrategicAxesBloc, AppState>(
          builder: (context, state) {
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
              final apiAxes = visionData.strategicAxises ?? [];
              final demoAxes = footballClubDemoStrategicAxes();
              final axisCount =
                  apiAxes.isNotEmpty ? apiAxes.length : demoAxes.length;
              final safeAxisIndex = axisCount == 0
                  ? 0
                  : _selectedAxisIndex.clamp(0, axisCount - 1);

              return ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                data: [
                  VisionSection(
                    visionTitle: visionData.title ?? '',
                    values: visionData.values ?? [],
                    messages: visionData.missions ?? [],
                  ),
                  SizedBox(height: 24.h),
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
                          axes: apiAxes,
                          axesDemoWhenEmpty: demoAxes,
                          selectedAxes: safeAxisIndex,
                          isStrategicAxes: true,
                          onAxisIndexChanged: (index) {
                            setState(() => _selectedAxisIndex = index);
                          },
                        ),
                        SizedBox(height: 8.h),
                        StrategicAxisObjectivesSection(
                          objectivesList: resolveStrategicAxisObjectives(
                            visionData,
                            safeAxisIndex,
                          ),
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
