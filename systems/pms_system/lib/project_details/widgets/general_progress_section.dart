import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/project_details/widgets/project_monthly_progress_section.dart';
import 'package:core_system/core/widgets/monthly_annaul_chart_filter_widget.dart';

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
      title: allTranslations.text(LocaleKeys.general_progress),
      withExpanded: false,
      withMargin: false,
      action: MonthlyAnnualChartFilterWidget(
        onSelect: (time) {
          setState(() {
            currentTime = time;
          });
        },
      ),
      child: currentTime == ChartTime.Month
          ? ProjectMonthlyProgressSection()
          : ProjectMonthlyProgressSection(),
    );
  }
}
