import 'package:strategy_system/strategic_axes/widgets/strategic_objectives_section.dart';

import '../../shared/strategy_exports.dart';

class StrategicAxisObjectivesSection extends StatelessWidget {
  final List<ObjectActiveModel> objectivesList;

  const StrategicAxisObjectivesSection({
    super.key,
    required this.objectivesList,
  });

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
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ).copyWith(bottom: 16.h),
          child: StrategicObjectivesSection(objectivesList: objectivesList),
        ),
      ],
    );
  }
}
