import 'package:core_system/core/widgets/monthly_annaul_chart_filter_widget.dart';
import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/project_details/bloc/project_general_progress_summary_bloc.dart';
import 'package:pms_system/project_details/widgets/project_monthly_progress_section.dart';

import '../../shared/pms_exports.dart';

class GeneralProgressSection extends StatelessWidget {
  final int projectId;

  const GeneralProgressSection({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectGeneralProgressSummaryBloc, AppState>(
      builder: (context, state) {
        final ProjectGeneralProgressSummaryBloc bloc = context
            .read<ProjectGeneralProgressSummaryBloc>();
        return state is Loading
            ? CustomShimmerContainer(height: 300)
            : CustomExpansionCard(
                title: allTranslations.text(LocaleKeys.general_progress),
                withExpanded: false,
                withMargin: false,
                action: MonthlyAnnualChartFilterWidget(
                  selectedTime: bloc.selectedChartType,
                  onSelect: (time) {
                    bloc.updateChartType(chartType: time, projectId: projectId);
                  },
                ),
                child: bloc.selectedChartType == ChartTime.Month
                    ? ProjectMonthlyProgressSection(
                        chartSeries: bloc.chartModel?.series ?? [],
                      )
                    : ProjectMonthlyProgressSection(
                        chartSeries: bloc.chartModel?.series ?? [],
                        isMonthly: false,
                      ),
              );
      },
    );
  }
}
