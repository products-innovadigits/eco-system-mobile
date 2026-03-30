import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';
import 'package:pms_system/features/employee_learning_details/widgets/competency_card.dart';

class CompetencyHighlightsSection extends StatelessWidget {
  const CompetencyHighlightsSection({
    super.key,
    required this.highestCompetency,
    required this.lowestCompetency,
  });

  final CompetencyItem? highestCompetency;
  final CompetencyItem? lowestCompetency;

  @override
  Widget build(BuildContext context) {
    if (highestCompetency == null && lowestCompetency == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          allTranslations.text(
            LocaleKeys.competency_highlights_from_last_review,
          ),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.color.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        if (highestCompetency != null)
          CompetencyCard(
            competency: highestCompetency!,
            type: CompetencyType.highest,
          ),
        if (lowestCompetency != null)
          CompetencyCard(
            competency: lowestCompetency!,
            type: CompetencyType.lowest,
          ),
      ],
    );
  }
}
