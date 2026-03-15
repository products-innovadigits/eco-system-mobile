import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

enum CompetencyType { highest, lowest }

class CompetencyCard extends StatelessWidget {
  const CompetencyCard({
    super.key,
    required this.competency,
    required this.type,
  });

  final CompetencyItem competency;
  final CompetencyType type;

  @override
  Widget build(BuildContext context) {
    final isHighest = type == CompetencyType.highest;
    final bgColor = isHighest
        ? LightColor.tertiary.withValues(alpha: 0.12)
        : LightColor.warning.withValues(alpha: 0.12);
    final accentColor = isHighest ? LightColor.tertiary : LightColor.warning;
    final icon = isHighest ? Icons.trending_up : Icons.trending_down;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: context.color.onPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22.w, color: accentColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHighest
                      ? allTranslations.text(LocaleKeys.highest)
                      : allTranslations.text(LocaleKeys.lowest),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.color.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  allTranslations.text(LocaleKeys.competency),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.color.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                competency.name,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              Text(
                competency.scoreLabel,
                style: context.textTheme.bodySmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
