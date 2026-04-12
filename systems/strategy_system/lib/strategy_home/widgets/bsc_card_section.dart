import 'package:core_system/core/widgets/custom_expansion_card.dart';
import 'package:strategy_system/bsc/bsc_perspective_home_mapper.dart';

import '../../shared/strategy_exports.dart';

List<ObjectiveKPIModel> _bscHomeCardRowsForState(AppState state) {
  if (state is Done) {
    final raw = state.data;
    if (raw is VisionDataModel) {
      final fromApi = objectiveKpiModelsFromManzors(raw.manzors);
      if (fromApi.isNotEmpty) return fromApi;
    }
  }
  return simulatedBscHomeCardPlaceholders();
}

class BscCardSection extends StatelessWidget {
  const BscCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BscBloc, AppState>(
      builder: (context, state) {
        // Old static preview (kept for reference — was shown for all states):
        // final List<ObjectiveKPIModel> list = [
        //   ObjectiveKPIModel(
        //     kpiTitle: 'المنظور المالي',
        //     color: '#175CD3',
        //     value: 80,
        //   ),
        //   ObjectiveKPIModel(
        //     kpiTitle: 'المنظور العملاء',
        //     value: 70,
        //     color: '#079455',
        //   ),
        //   ObjectiveKPIModel(
        //     kpiTitle: 'المنظور العمليات الداخلية',
        //     value: 60,
        //     color: '#DC6803',
        //   ),
        //   ObjectiveKPIModel(
        //     kpiTitle: 'المنظور التعلم والنمو',
        //     value: 90,
        //     color: '#175CD3',
        //   ),
        // ];

        final List<ObjectiveKPIModel> list = _bscHomeCardRowsForState(state);
        return CustomExpansionCard(
          title: allTranslations.text("bsc"),
          action: InkWell(
            onTap: () => CustomNavigator.push(Routes.BSC),
            child: Text(
              allTranslations.text(LocaleKeys.view_more),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.color.secondary,
              ),
            ),
          ),
          withExpanded: false,
          withMargin: false,
          child: Column(
            children: List.generate(list.length, (i) {
              final color = list[i].color?.replaceFirst('#', '0xff').toString();
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        list[i].kpiTitle ?? "",
                        style: context.textTheme.bodySmall,
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
                            minHeight: 6.h,
                            color: Color(int.parse(color ?? '0xFF000000')),
                            backgroundColor: Color(
                              int.parse(color ?? '0xFF000000'),
                            ).withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${list[i].value ?? ""}%",
                      style: context.textTheme.labelSmall,
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

