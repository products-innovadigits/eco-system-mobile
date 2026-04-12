import 'package:core_system/core/widgets/custom_expansion_card.dart';
import 'package:strategy_system/okr/okr_demo_football_club_data.dart';

import '../../shared/strategy_exports.dart';

class OkrCardSection extends StatelessWidget {
  const OkrCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ObjectiveKPIModel> list = okrFootballClubDemoHomeCardRows();
    return CustomExpansionCard(
      title: allTranslations.text(LocaleKeys.okr),
      action: InkWell(
        onTap: () => CustomNavigator.push(Routes.OKR),
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
                  "${(list[i].value ?? 0).toStringAsFixed(0)}%",
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
