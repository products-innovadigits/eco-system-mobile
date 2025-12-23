import 'package:core_system/core/widgets/monthly_annaul_chart_filter_widget.dart';
import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/project_details/bloc/general_progress/project_general_progress_summary_bloc.dart';
import 'package:pms_system/project_details/bloc/general_progress/project_general_progress_summary_state.dart';
import 'package:pms_system/project_details/widgets/project_monthly_progress_section.dart';

import '../../shared/pms_exports.dart';

class GeneralProgressSection extends StatelessWidget {
  final int projectId;
  final bool? withFiltration;

  const GeneralProgressSection({
    super.key,
    required this.projectId,
    this.withFiltration = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectGeneralProgressSummaryBloc,
        ProjectGeneralProgressSummaryState>(
      builder: (context, state) {
        final ProjectGeneralProgressSummaryBloc bloc =
            context.read<ProjectGeneralProgressSummaryBloc>();
        return state is ProjectGeneralProgressSummaryLoading
            ? CustomShimmerContainer(height: 300)
            : CustomExpansionCard(
                title: allTranslations.text(LocaleKeys.general_progress),
                withExpanded: false,
                withMargin: false,
                action:
                    (withFiltration == true &&
                        (bloc.chartModel?.series ?? []).isNotEmpty)
                    ? MonthlyAnnualChartFilterWidget(
                        selectedTime: bloc.selectedChartType,
                        onSelect: (time) {
                          bloc.updateChartType(
                            chartType: time,
                            projectId: projectId,
                          );
                        },
                      )
                    : null,
                child: (bloc.chartModel?.series ?? []).isNotEmpty
                    ? bloc.selectedChartType == ChartTime.Month
                          ? ProjectMonthlyProgressSection(
                              chartSeries: bloc.chartModel?.series ?? [],
                            )
                          : ProjectMonthlyProgressSection(
                              chartSeries: bloc.chartModel?.series ?? [],
                              isMonthly: false,
                            )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            allTranslations.text(LocaleKeys.there_is_no_data),
                          ),
                        ),
                      ),
              );
      },
    );
  }
}
