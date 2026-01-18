import 'package:core_system/core/utility/export.dart';
import 'package:intl/intl.dart';
import 'package:strategy_system/objective_details/model/objective_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ObjectiveLineChart extends StatelessWidget {
  final List<ObjectiveChartModel> data;
  final bool isMonthly;

  const ObjectiveLineChart({
    super.key,
    required this.data,
    this.isMonthly = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double targetBarPx = data.length > 3 ? 60 : 40;
        double minSeriesWidth = data.length > 3 ? 0.12 : 0.12;
        double maxSeriesWidth = data.length > 3 ? 0.5 : 0.6;
        final double plotWidth = constraints.maxWidth;
        double seriesWidth = (data.length * targetBarPx) / plotWidth;
        seriesWidth = seriesWidth.clamp(minSeriesWidth, maxSeriesWidth);
        return SfCartesianChart(
          tooltipBehavior: _tooltip,
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
            zoomMode: ZoomMode.x,
          ),
          primaryXAxis: CategoryAxis(
            isInversed: true,
            autoScrollingDelta: 4,
            autoScrollingMode: AutoScrollingMode.start,
            interval: 1,
            labelIntersectAction: AxisLabelIntersectAction.wrap,
            maximumLabelWidth: 200,
            axisLine: AxisLine(width: 1, color: context.color.outline),
            labelStyle: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
              fontSize: 10,
            ),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 100,
            interval: 20,
            opposedPosition: true,
            numberFormat: NumberFormat("##'%'"),
            axisLine: AxisLine(width: 1, color: context.color.outline),
            labelStyle: context.textTheme.bodySmall?.copyWith(
              color: context.color.outlineVariant,
              fontSize: 10,
            ),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: [
            ColumnSeries<ObjectiveChartModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => isMonthly
                  ? AppCore.getMonthName(m.month ?? 13)
                  : m.year.toString(),
              yValueMapper: (m, _) => m.objectValue,
              color: context.color.secondary,
              width: seriesWidth,
              borderRadius: BorderRadius.circular(16),
              borderColor: LightColor.white,
              borderWidth: 2,
              animationDuration: 800,
              // pointWidth: 12,
            ),
            StackedColumnSeries<ObjectiveChartModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => isMonthly
                  ? AppCore.getMonthName(m.month ?? 13)
                  : m.year.toString(),
              yValueMapper: (m, _) => m.initiativesValue,
              color: context.color.primary,
              width: seriesWidth,
              borderRadius: BorderRadius.circular(16),
              borderColor: LightColor.white,
              borderWidth: 2,
              animationDuration: 800,
              // pointWidth: 12,
            ),
            StackedColumnSeries<ObjectiveChartModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => isMonthly
                  ? AppCore.getMonthName(m.month ?? 13)
                  : m.year.toString(),
              yValueMapper: (m, _) => m.kpisValue,
              color: context.color.tertiary,
              width: seriesWidth,
              borderRadius: BorderRadius.circular(16),
              borderColor: LightColor.white,
              borderWidth: 2,
              animationDuration: 800,
              // pointWidth: 12,
            ),
          ],
        );
      },
    );
  }
}

final TooltipBehavior _tooltip = TooltipBehavior(
  enable: true,
  header: '',
  canShowMarker: false,
  tooltipPosition: TooltipPosition.pointer,
  color: const Color(0xFF0C9A84),
  builder:
      (
        dynamic data,
        dynamic point,
        dynamic series,
        int pointIndex,
        int seriesIndex,
      ) {
        final m = data as ObjectiveChartModel;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0C9A84),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${allTranslations.text(LocaleKeys.objective)} '
                '${m.objectValue}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${m.initiativesValue}% '
                    '${allTranslations.text(LocaleKeys.initiative)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${m.kpisValue}% '
                    '${allTranslations.text(LocaleKeys.kpi)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
);
