import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/shared/widgets/monthly_annaul_chart_filter_widget.dart';

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
    return BlocBuilder<
      ProjectGeneralProgressSummaryBloc,
      ProjectGeneralProgressSummaryState
    >(
      builder: (context, state) {
        final ProjectGeneralProgressSummaryBloc bloc = context
            .read<ProjectGeneralProgressSummaryBloc>();
        return state is ProjectGeneralProgressSummaryLoading
            ? CustomShimmerContainer(height: 300)
            : CustomExpansionCard(
                title: allTranslations.text(LocaleKeys.general_progress),
                withExpanded: false,
                withMargin: false,
                action: (withFiltration == true)
                    // && (bloc.chartModel?.series ?? []).isNotEmpty)
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
                child: (bloc.chartModel != null)
                    ? bloc.selectedChartType == ChartTime.monthly
                          ? ProjectMonthlyProgressSection(
                              progressModel: bloc.chartModel!,
                            )
                          : ProjectMonthlyProgressSection(
                              progressModel: bloc.chartModel!,
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
