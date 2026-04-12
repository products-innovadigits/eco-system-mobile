import 'package:core_system/core/widgets/main_card_widget.dart';
import 'package:strategy_system/strategy_home/data/football_club_kpi_initiatives_progress_demo.dart';

import '../../shared/strategy_exports.dart';

class KpiInitiativesProgressSection extends StatelessWidget {
  const KpiInitiativesProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(LocaleKeys.kpis_initiatives_objective),
      child: Column(
        children: [
          ObjectivesKpisInitiativesChart(
            data: footballClubKpiInitiativesProgressDemo(),
          ),
          const SizedBox(height: 12),
          _buildChartTitles(context),
        ],
      ),
    );
  }
}

Widget _buildChartTitles(BuildContext context) {
  return Wrap(
    alignment: WrapAlignment.start,
    direction: Axis.horizontal,
    runSpacing: 8.w,
    spacing: 24.h,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: context.color.primary, size: 14),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              allTranslations.text("kpis"),
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: context.color.tertiary, size: 14),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              allTranslations.text(LocaleKeys.initiatives),
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    ],
  );
}
