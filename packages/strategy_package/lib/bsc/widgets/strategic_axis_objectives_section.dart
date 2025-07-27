import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/widgets/objectives_bottom_sheet.dart';

import '../../shared/strategy_exports.dart';

class StrategicAxisObjectivesSection extends StatelessWidget {
  const StrategicAxisObjectivesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
      expansionAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
      title: Text(
        allTranslations.text(LocaleKeys.objectives),
        style: context.textTheme.labelMedium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.color.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.color.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      iconColor: context.color.secondary,
      collapsedIconColor: context.color.outlineVariant,
      collapsedTextColor: context.color.onSurface,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 16.h),
          child: ObjectivesBottomSheet(
            isStrategicAxis: true,
            objectivesList: [
              ObjectActiveModel(
                title: 'Title 1',
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
            ],
          ),
        ),
      ],
    );
  }
}
