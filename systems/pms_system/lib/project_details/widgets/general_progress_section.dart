import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/project_details/widgets/project_monthly_progress_section.dart';

import '../../shared/pms_exports.dart';

class GeneralProgressSection extends StatefulWidget {
  const GeneralProgressSection({super.key});

  @override
  State<GeneralProgressSection> createState() => _GeneralProgressSectionState();
}

class _GeneralProgressSectionState extends State<GeneralProgressSection> {
  ChartTime currentTime = ChartTime.Month;

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      title: allTranslations.text("general_progress"),
      withExpanded: false,
      action: Row(
          children: List.generate(
        ChartTime.values.length,
        (i) => InkWell(
          onTap: () => setState(() {
            currentTime = ChartTime.values[i];
            // scrollToBottom();
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: currentTime == ChartTime.values[i]
                  ? context.color.primary
                  : context.color.secondary.withValues(alpha: 0.1),
            ),
            child: Text(
              allTranslations.text(ChartTime.values[i].name),
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: currentTime == ChartTime.values[i]
                    ? context.color.onPrimary
                    : context.color.primary,
              ),
            ),
          ),
        ),
      )),
      child: currentTime == ChartTime.Month
          ? ProjectMonthlyProgressSection()
          : ProjectMonthlyProgressSection(),
    );
  }
}
